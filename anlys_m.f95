      program analyze_mmotor
        implicit none
        real ::  arlm, a2rlm, rdrlm, afptm, a2fptm, rdfptm
        real :: astm, a2stm, rdstm, f0, l0, vrlm, vfptm, vstm
        real :: avlm, a2vlm, vvlm, rdvlm
        real, allocatable :: arl(:), a2rl(:), afpt(:), a2fpt(:)
        real, allocatable :: ast(:), a2st(:), vrl(:), vfpt(:), vst(:)
        real, allocatable :: rdrl(:), rdfpt(:), rdst(:)
        real, allocatable :: avl(:), a2vl(:), vvl(:), rdvl(:)
        integer :: i, j, k, ps, samp, nos
        character(len = 32) :: rundata, stime, counts, idx, param, avg

        open(unit=17,file='pos.dat')
          read(17,*) ps
        close(unit=17)

        open(unit=18,file='f0.dat')
          read(18,*) f0
        close(unit=18)

        open(unit=27,file='vari.dat')
          read(27,*) nos
        close(unit=27)

        allocate(arl(nos),afpt(nos),ast(nos), avl(nos))
        allocate(a2rl(nos),a2fpt(nos),a2st(nos),a2vl(nos))
        allocate(vrl(nos),vfpt(nos),vst(nos),vvl(nos))
        allocate(rdrl(nos),rdfpt(nos),rdst(nos),rdvl(nos))

        open(unit = 41, file ='l0.dat')
        do samp = 1,nos
        read(41,*) l0

        !File naming :
          write(idx,'(I1.0)') samp
          rundata = 'sls'//trim(idx)//'_rundata.dat'
          stime = 'sls'//trim(idx)//'_stime.dat'
          counts = 'sls'//trim(idx)//'_counts.dat'
          param = 'sls'//trim(idx)//'_para.dat'
          avg = 'sls'//trim(idx)//'_avg.dat'

        open(unit=1, file = avg)
        read(1,*)  arl(samp)
        read(1,*)  a2rl(samp)
        read(1,*)  afpt(samp)
        read(1,*)  a2fpt(samp)
        read(1,*)  avl(samp)
        read(1,*)  a2vl(samp)
        read(1,*)  ast(samp)
        read(1,*)  a2st(samp)
        read(1,*)  vrl(samp)
        read(1,*)  vfpt(samp)
        read(1,*)  vvl(samp)
        read(1,*)  vst(samp)
        read(1,*)  rdrl(samp)
        read(1,*)  rdfpt(samp)
        read(1,*)  rdvl(samp)
        read(1,*)  rdst(samp)
        close(unit=1)

        end do
        close(unit = 41)


        open(unit=4, file = 'dyn_avg.dat')
        read(4,*)  arlm
        read(4,*)  a2rlm
        read(4,*)  afptm
        read(4,*)  a2fptm
        read(4,*)  avlm
        read(4,*)  a2vlm
        read(4,*)  astm
        read(4,*)  a2stm
        read(4,*)  vrlm
        read(4,*)  vfptm
        read(4,*)  vvlm
        read(4,*)  vstm
        read(4,*)  rdrlm
        read(4,*)  rdfptm
        read(4,*)  rdvlm
        read(4,*)  rdstm
        close(unit=4)

        open(unit =11, file = 'avg_runl.dat', access = 'APPEND')
        open(unit =12, file = 'avg_fpt.dat', access = 'APPEND')
        open(unit =13, file = 'avg_st.dat', access = 'APPEND')
        open(unit =14, file = 'avg_vl.dat', access = 'APPEND')
        open(unit =21, file = 'rd_runl.dat', access = 'APPEND')
        open(unit =22, file = 'rd_fpt.dat', access = 'APPEND')
        open(unit =23, file = 'rd_st.dat', access = 'APPEND')
        open(unit =24, file = 'rd_vl.dat', access = 'APPEND')
        open(unit =31, file = 'var_runl.dat', access = 'APPEND')
        open(unit =32, file = 'var_fpt.dat', access = 'APPEND')
        open(unit =33, file = 'var_st.dat', access = 'APPEND')
        open(unit =34, file = 'var_vl.dat', access = 'APPEND')

        write(11,*) f0, arl, arlm
        write(12,*) f0, afpt, afptm
        write(13,*) f0, ast, astm
        write(14,*) f0, avl, avlm
        write(21,*) f0, rdrl, rdrlm
        write(22,*) f0, rdfpt, rdfptm
        write(23,*) f0, rdst, rdstm
        write(24,*) f0, rdvl, rdvlm
        write(31,*) f0, vrl, vrlm
        write(32,*) f0, vfpt, vfptm
        write(33,*) f0, vst, vstm
        write(34,*) f0, vvl, vvlm

        close(unit=11)
        close(unit=12)
        close(unit=13)
        close(unit=14)
        close(unit=21)
        close(unit=22)
        close(unit=23)
        close(unit=24)
        close(unit=31)
        close(unit=32)
        close(unit=33)
        close(unit=34)

      end program analyze_mmotor
