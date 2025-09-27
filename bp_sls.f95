       program multiple_motor_dynein
        implicit none
        real :: pi, e, norm, ran2, eps, f, fd, k, binx, bint, binst
        real :: bint2, binst2, b2, dt, l0
        real :: ks, kstep, x, d, pi_n, fs, x_av, t_av, max_x, max_t
        real :: t_i, x_i, x_av2, t_av2, k_trap, f0, Edf, alpha, v0
        real :: st_av, st_i, max_st, t_b, c1, c2, c3, lmax_t, lmax_st
        real :: binv, max_v, c4, v_i
        real, allocatable :: P(:), run_l(:), run_t(:), stal_t(:)
        real, allocatable :: psi_x(:), psi_t(:), psi_st(:)
        real, allocatable :: psi2_t(:), psi2_st(:), pst(:)
        real, allocatable :: psi_v(:)
        integer :: i, j, t_mc, t_wait, inp, state, bound, unbound, N
        integer :: st, iter, t_dc, i_b, walk, bn, t_stall, flag, js
        integer :: stc, cnt, a, b, a2, bn2, bn3, a3, samp, bnv
        integer, allocatable :: st_state(:), bin_x(:), bin_t(:)
        integer, allocatable :: bin_st(:), bin2_t(:), bin2_st(:)
        integer, allocatable :: binn(:), bin_v(:)
        character(len = 32) :: rundata, stime, counts, fnm, param
        character(len = 32) :: xdata, tdata, stdata, ltdata, lstdata
        character(len = 32) :: stsdata, linfit, vdata

        open(unit = 19,file = "binpara.dat")

        !Set No. of bin points
        read(19,*) bn
        write(*,*) "Number of bin points required for x:",bn
        read(19,*) bn2
        write(*,*) "Number of bin points required for t:",bn2


        !Set Max values
        read(19,*) max_x
        write(*,*) "Set binning threshold max_x: ", max_x
        read(19,*) max_t
        write(*,*) "Set time binning threshold max_t: ",max_t

        close(unit = 19)

        !Initialize binning arrays :
        allocate (bin_x(bn), bin_t(bn2))
        allocate (psi_x(bn), psi_t(bn2))

        bin_x = 0
        bin_t = 0

        binx = max_x/real(bn)
        bint = max_t/real(bn2)

        open(unit = 41, file = 'filename2.txt')
        read(41,*) fnm
        close(unit=41)

        !File naming :
        rundata = trim(fnm)//'_rundata.dat'
        counts = trim(fnm)//'_counts.dat'
        param = trim(fnm)//'_para.dat'
        xdata = trim(fnm)//'_xdata.dat'
        tdata = trim(fnm)//'_tdata.dat'

        open(unit = 18, file = counts)
        !Number of motors:
        read(18,*) N
        write(*,*) "Number of motors :", N
        write(*,*) "Specify iter and js :"
        read(18,*) iter
        write(*,*) iter
        read(18,*) pi
        read(18,*) e
        read(18,*) v0
        read(18,*) d
        read(18,*) fd
        read(18,*) fs
        read(18,*) dt
        write(*,*) 'dt =', dt

        close(unit = 18)

        !Normalize the rates first
        cnt = 0
        bin_x = 0
        bin_t = 0

        open(unit = 23, file = rundata)
        !To do binning for run_lengths

        do j=1,iter
          read(23,*) a, c1, c2
            cnt = cnt + 1
          do i = 1, bn
            if(c1 <= (max_x/real(bn))*i)then
              bin_x(i) = bin_x(i) + 1
              exit
            end if
          end do

        !To do binning for run_times using regular scale
          do i = 1, bn2
            if(c2 <= (max_t/real(bn2))*i)then
              bin_t(i) = bin_t(i) + 1
              exit
            end if
          end do

        end do
        close(unit = 23 )

        !Construction of the frequency distributions
        open(unit = 49, file = xdata)
        do i = 1,bn
        x_i = (max_x*(2*i-1))/(2*real(bn))
        psi_x(i) =  real(bin_x(i))/real(cnt)
        write(49,*) x_i , psi_x(i)/binx
        end do
        close(unit = 49)

        open( unit = 50, file = tdata)
        do i = 1,bn2
        t_i =  (max_t*(2*i-1))/(2*real(bn2))
        psi_t(i) =  real(bin_t(i))/real(cnt)
        write(50,*) t_i , psi_t(i)/bint
        end do
        close(unit = 50 )


       !To check Normalization of the distributions:
        write(*,*) "Norm: ", sum(psi_x), sum(psi_t)

      end program multiple_motor_dynein
