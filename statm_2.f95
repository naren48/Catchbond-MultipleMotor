      program stat_motor
        implicit none
        real :: x, t, s, avg_rl, avg_st, avg_fpt, avg_rl2
        real :: avg_st2, avg_fpt2, disp_rl, disp_st, disp_fpt
        real :: sd_rl, sd_fpt, sd_st, l0, avg_vl, avg_vl2
        real :: disp_vl, sd_vl, v
        integer :: N, iter, js, i, j, i1, j1, j2, samp, jsm
        character(len=40) :: fname
        real, allocatable :: rl(:), rl2(:), fpt(:), fpt2(:)
        real, allocatable :: st(:), st2(:), vl(:), vl2(:)
        character(len = 32) :: rundata, stime, counts, idx, param
        character(len = 32) :: avg, fnm

        open(unit = 41, file = 'filename2.txt')
        read(41,*) fnm
        close(unit = 41)

        !File naming :
          rundata = trim(fnm)//'_rundata.dat'
          stime = trim(fnm)//'_stime.dat'
          counts = trim(fnm)//'_counts.dat'
          param = trim(fnm)//'_para.dat'
          avg = trim(fnm)//'_avg.dat'

        !---------------------------------------------------------
        ! 1. Read number of counts
        !---------------------------------------------------------
        open(unit = 11, file = counts)
        read(11,*) N
        read(11,*) iter
        read(11,*) js
        close(unit = 11)

        allocate(rl(iter), rl2(iter))
        allocate(fpt(iter), fpt2(iter))
        allocate(vl(iter), vl2(iter))
        allocate(st(js), st2(js))


        !---------------------------------------------------------
        ! 2. Generate file for sqaures
        !---------------------------------------------------------
        open(unit = 21, file = rundata)
        !open(unit = 31, file = 'run_l.dat')
        !open(unit = 32, file = 'fpt.dat')

        do i = 1,iter
          read(21,*) i1, x, t, v
          rl(i) = x
          rl2(i) = x*x
          fpt(i) = t
          fpt2(i) = t*t
          vl(i) = v
          vl2(i) = v*v
        end do

        close(unit = 21)

        open(unit = 22, file = stime)

        if(js >0)then
          do j = 1,js
            read(22,*) j1, j2, s
            st(j) = s
            st2(j) = s*s
          end do
        end if

        close(unit = 22)
        !close(unit = 32)
        !close(unit = 31)

        !---------------------------------------------------------
        ! 3. Generate averages and dispersion
        !---------------------------------------------------------

        avg_rl = sum(rl)/real(iter)
        avg_rl2 = sum(rl2)/real(iter)
        avg_fpt = sum(fpt)/real(iter)
        avg_fpt2 = sum(fpt2)/real(iter)
        avg_vl = sum(vl)/real(iter)
        avg_vl2 = sum(vl2)/real(iter)

        if(js >0)then
          avg_st = sum(st)/real(js)
          avg_st2 = sum(st2)/real(js)
        end if

        sd_rl = sqrt(avg_rl2 - avg_rl**2)
        sd_fpt = sqrt(avg_fpt2 - avg_fpt**2)
        sd_vl = sqrt(avg_vl2 - avg_vl**2)
        disp_rl = (avg_rl2 - avg_rl**2)/(avg_rl**2)
        disp_fpt = (avg_fpt2 - avg_fpt**2)/(avg_fpt**2)
        disp_vl = (avg_vl2 - avg_vl**2)/(avg_vl**2)

        if(js >0)then
          sd_st = sqrt(avg_st2 - avg_st**2)
          disp_st = (avg_st2 - avg_st**2)/(avg_st**2)
        end if
        !---------------------------------------------------------
        ! 4. Record values
        !---------------------------------------------------------

        open(unit = 4, file = avg)
        write(4,*)  avg_rl
        write(4,*)  avg_rl2
        write(4,*)  avg_fpt
        write(4,*)  avg_fpt2
        write(4,*)  avg_vl
        write(4,*)  avg_vl2
        write(4,*)  avg_st
        write(4,*)  avg_st2
        write(4,*)  sd_rl
        write(4,*)  sd_fpt
        write(4,*)  sd_vl
        write(4,*)  sd_st
        write(4,*)  disp_rl
        write(4,*)  disp_fpt
        write(4,*)  disp_vl
        write(4,*)  disp_st
        write(4,*) 'Average run-length'
        write(4,*) 'Average sqaure of run-length'
        write(4,*) 'Average first passage time'
        write(4,*) 'Average sqaure of first passage time'
        write(4,*) 'Average of Average velocity'
        write(4,*) 'Average sqaure of Average velocity'
        write(4,*) 'Average stall-time'
        write(4,*) 'Average sqaure of stall-time'
        write(4,*) 'Standard Deviation of run-length'
        write(4,*) 'Standard Deviation of first passage time'
        write(4,*) 'Standard Deviation of Average velocity'
        write(4,*) 'Standard Deviation of stall-time'
        write(4,*) 'Dispersion of run-length'
        write(4,*) 'Dispersion of first passage time'
        write(4,*) 'Dispersion of Average Velocity'
        write(4,*) 'Dispersion of stall-time'
        close(unit = 4)

      end program stat_motor
