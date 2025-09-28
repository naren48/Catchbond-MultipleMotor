       program stochastic_loadsharing
      use mt19937_64
      real :: pi, e, d, v0, ks, l0, ch, dt, init_x, alpha
      real :: xc, x, xe, xb, gm, k_trap, km, fb, fd, st
      real :: f0, fs, eps, ksm, r1, rc1, rc2, t, rlen
      real :: pi_n, fb1, fm, rch, start, finish
      integer :: N, bnd, act, i, j, iter, mvflag
      integer :: stall, ust, js, init_st, samp,nch
      integer*8 :: seed
      real, allocatable :: mx(:), run_l(:), run_t(:), mf(:)
      real, allocatable :: avg_v(:)
      integer, allocatable :: ms(:)
      character(len = 32) :: rundata, stime, counts, fnm, param
      character(len = 32) :: traj, avg

      !------------------------------------------------------------------
      !PARAMETER VALUES :
      !------------------------------------------------------------------
      call cpu_time(start)
      !To read parameter values from file:
      open( unit = 2, file = 'para2.dat')
      read(2,*) N
      read(2,*) pi
      read(2,*) e
      read(2,*) d
      read(2,*) v0
      read(2,*) fd
      read(2,*) fs
      read(2,*) fm
      read(2,*) f0
      read(2,*) alpha
      read(2,*) iter
      read(2,*) k_trap
      read(2,*) l0
      read(2,*) km
      read(2,*) dt
      close( unit = 2)

      allocate(mx(N), ms(N), mf(N))
      allocate(run_l(iter), run_t(iter), avg_v(iter))

       open(unit = 41, file = 'filename2.txt')
          read(41,*) fnm
       close(unit = 41)

       !File naming :
       rundata = trim(fnm)//'_rundata.dat'
       stime = trim(fnm)//'_stime.dat'
       counts = trim(fnm)//'_counts.dat'
       param = trim(fnm)//'_para.dat'
       traj = trim(fnm)//'_traj.dat'
       avg = trim(fnm)//'_avg.dat'

       !Declare Parameters
       open(unit = 43, file = param)
       write(43,*) "Number of motors N: ",N
       write(43,*) "pi: ",pi
       write(43,*) "e: ",e
       write(43,*) "d: ",d
       write(43,*) "velocity v0: ",v0
       write(43,*) "rest length l0: ", l0
       write(43,*) "Number of iterations: ", iter
       write(43,*) "trap-strength k_trap: ", k_trap
       write(43,*) "motor stiffness km: ", km
       write(43,*) "dt: ",dt
       write(43,*) "fd: ",fd
       write(43,*) "fs: ",fs
       write(43,*) "fm: ",fm
       write(43,*) "f0: ", f0
       write(43,*) "alpha: ",alpha
       close(unit = 43)

       !Derived parameters :
       ks = v0/d
       bnd = 2*l0/d
       gm = k_trap/km

     !--------------------------------------------------------------------
     !RANDOM NUMBER GENERATOR : Mersenne twister
     !--------------------------------------------------------------------

      !To call random numbers initialize the generator:
      seed = time()
      call init_genrand64(seed)

     !--------------------------------------------------------------------
     !INITIALIZATION OF CARGO : Comment out the unnecessary section -
     !--------------------------------------------------------------------

      open(unit = 1, file = rundata)
      open(unit = 5, file = traj)

      js = 1

      do j = 1,iter
      !For initial stategfort N:
      mx = 0
      ms = 0
      rch = genrand64_real1()
      nch = int(N*rch) + 1
      ms(nch) = 1
          !Random choice of binding site:
          ch = genrand64_real1()
          mx(nch) = l0 - (int((bnd+1)*ch))*d

        t = 0.0
        mf = 0.0
        x = 0.0
        ust = 1
        !27.11.2020 : Initialize move flag
        mvfl = 0
      !-------------------------------------------------------------------
      !TIME LOOP :
      !-------------------------------------------------------------------

      do

        !Abort walk if there are no bound motors
         if(sum(ms) == 0)then
            run_l(j) = x - init_x
            run_t(j) = t
            write(1,*) j, run_l(j), run_t(j)
            exit
          end if

          !1. Force Balance :
          !-------------------------------------------------------------------

          !Force balance disturbed
          if(abs(sum(mf) + k_trap*x ) > 1e-03)then

            xb = x
            !To calculate position for force balance :
            do

              xe = 0
              ! Boundaries of the threshold
              x_b2 = xb - l0
              x_b1 = xb + l0

              !To determine pulling motors and calculate force balance
              act = 0
              do i = 1,N
                !if(abs(mf(i)) > 0)then
                  if(mx(i) < xb .and. mx(i) <= x_b2)then
                    xe = xe + mx(i) + l0
                    act = act + 1
                  elseif(mx(i) > xb .and. mx(i) >= x_b1)then
                    xe = xe + mx(i) - l0
                    act = act + 1
                  end if
                !end if
              end do

              !Test balance in both cases
              if(act > 0 ) then
                xb = (xe)/(act + gm)
              else
                xb = (maxval(mx) - l0)/(1 + gm)
                if(xb < 0)then
                  xb = 0.0
                end if
                if(k_trap*x == 0)then
                  xb = x
                  exit
                end if
              end if

            ! Recalculation of Motor forces to check balance:
            do i=1,N
              if(ms(i) == 1)then
                 if(abs(mx(i) - xb) >= l0)then
                    if(mx(i) > xb)then
                       mf(i) = -km*(mx(i) - xb - l0)
                    else
                       mf(i) = -km*(mx(i) - xb + l0)
                    end if
                 else
                    mf(i) = 0
                 end if
              else
                 mf(i) = 0
              end if
              !write(*,*) i, ms(i), mx(i), mf(i), xb
            end do

            ! To assign inactive motor postion
            do i=1,N
              if( ms(i) == 0)then
                 mx(i) = xb
              end if
            end do

            ! Assign test balance position to actual if balanced
            if(abs(sum(mf) + k_trap*xb) < 1e-03)then
              x = xb
              exit
              !else
              !write(*,*) abs(sum(mf)), k_trap*xb
            end if
          end do

          end if

          ! Record trajectory data
    !      write(5,*) j, t, x, mx, sum(ms)

      !3. Monte Carlo Move for Motors :
      !-------------------------------------------------------------------

      !a. Simultaneous update :
      !-------------------------------------------------------------------

        do i=1,N
         fb = -mf(i)
         if(ms(i) == 1)then
        !Calculation of rates:
            !Calculation of deformation energy :
            fb1 = abs(fb)
            if( fb1 < fm)then
              Edf = 0
            else
              Edf = alpha*(1 - exp(-((fb1-fm)/(f0))))
            end if
            !Calculation of unbinding rate :
            eps = e*exp( -Edf + fb1/(fd))

            !Calculation of Stepping rate:
            if(fb > 0 .and. fb < fs)then
               ksm = ks*(1 - (fb/fs))
            else if(fb .ge. fs )then
               ksm = 0
            else if(fb <= 0)then
               ksm = ks
            end if

            !Calculation of binding rate :
            pi_n = 0.0

            !Monte Carlo move:
            r1 = genrand64_real1()
            if(r1 < eps*dt)then
               ms(i) = 0
            else if(r1 < (eps + ksm)*dt )then
               mx(i) = mx(i) + d
            end if

         else if(ms(i) == 0)then
            eps = 0.0
            ksm = 0.0
            pi_n = pi

            !Monte carlo move:
            r1 = genrand64_real1()
            if(r1 < pi_n*dt)then
               ms(i) = 1
               rc2 = genrand64_real1()
               x_b1 = x + l0
               !If the rest-length is comparable to the step-size
               if(l0 < 4)then
                 up_l = nint((x_b1-l0)/d)*d + l0
                 mx(i) = up_l - (int(rc2*(bnd+1)))*d
               else if( l0 >= 4 )then
                 up_l = int((x_b1-l0)/d)*d + l0
                 mx(i) = up_l - (int(rc2*(bnd+1)))*d
               end if
            end if

         end if

        end do

        !Recalculation of motor forces after motor position update
        do i=1,N
          if(ms(i) == 1)then
             if(abs(mx(i) - x) >= l0)then
                if(mx(i) > x)then
                   mf(i) = -km*(mx(i) - x - l0)
                else
                   mf(i) = -km*(mx(i) - x + l0)
                end if
             else
                mf(i) = 0
             end if
          else
             mf(i) = 0
          end if
        end do

        t = t + dt

        !27.11.2020 : Correction to FPT Calculation -
        !We start counting from the point the leading motor walks out of the threshold.
        if(maxval(mx) > l0)then
          mvfl = mvfl + 1
        end if

        if(mvfl == 1)then
          t = 0
        end if

      end do

      end do

      close(unit = 1)
      close(unit = 5)


      !4. Calculation of  :
      !-------------------------------------------------------------------

      !Calculation of averages and normalized probabilities
        x_av = sum(run_l)/real(iter)
        t_av = sum(run_t)/real(iter)

      !Display avergaes
        write(*,*) "Average walk length :", x_av
        write(*,*) "Average walk time :", t_av

      !Record Averages
        open(unit = 5, file = avg)
          write(5,*) "Average_Runlength: ", x_av
          write(5,*) "Average_FPT:" , t_av
        close(unit = 5)


      !Store parameters of counts :
        open(unit = 18, file = counts)
               write(18,*) N
               write(18,*) iter
               write(18,*) pi
               write(18,*) e
               write(18,*) v0
               write(18,*) d
               write(18,*) fd
               write(18,*) fs
               write(18,*) dt
        close(unit = 18)
      !------------------------------------------------------------------
      call cpu_time(finish)
      write(*,*) 'Time =',finish-start

      end program stochastic_loadsharing
