#!/bin/sh

# To remove existing files and directories
rm -rf avg_*.dat
rm -rf rd_*.dat
rm -rf var_*.dat
rm -rf *.png

rm -rf  FPT && mkdir  FPT
rm -rf  FPTLG && mkdir  FPTLG
rm -rf  RUNL && mkdir  RUNL
rm -rf  STS && mkdir  STS
rm -rf  STT && mkdir  STT
rm -rf  STTLG && mkdir  STTLG
rm -rf  VL && mkdir  VL
rm -rf  UVSF && mkdir  UVSF

#Compile the programs to be run :

  #Unbinding-force curve
  gfortran uvsa.f95 -o uvsa.x

  # Mean-Field Loadsharing programs :
  gfortran dyne_2.f95 mt_rng.f95 -o dyne.x

  gfortran bp_mf.f95 -o bp_mf.x

  gfortran statmf.f95 -o statmf.x

  # Stochastic loadsharing programs
  gfortran stoch_ls.f95 mt_rng.f95 -o stoch_ls.x

  gfortran bp_sls.f95 -o bp_sls.x

  gfortran statm.f95 -o statm.x

  # Program for compiling Statistical quantities vs f0
  gfortran anlys_n.f95 -o anlys_N.x

# To run simulations and compile plots for multiple parameter values
N=1
j=0
targ=vary_N_till15

rm -rf  $targ && mkdir $targ

#Loop 1 : To loop over given values of f0 in the file
while [ "$j" -lt 15 ];
do
  j=$(( $j + 1 ))

  echo $N > nmotor.dat
  line=N$N
  echo $line > filen.dat
  echo $j > pos.dat

  #To modify parameter file to replace value for f0
  > para.dat
  sed '1c\'"$N"'' sim_para.dat > para.dat

  #Plot the unbinding rate curve
  ./uvsa.x
  gnuplot plot_uvsa.plt

  #Run Mean-field Simulation with binning and stats
  i1=0
  while read alpha ; do

    i1=`expr $i1 + 1`
    echo $i1

    > filename1.txt
    echo "dyn$i1" >> filename1.txt

    #parameters change
      > para1.dat
      sed "9c$alpha" para.dat > para1.dat

      ./dyne.x
      ./bp_mf.x
      ./statmf.x

  done < alpha.dat
  #number of variants to be plotted together simultaneously
  echo $i1 > vari1.dat

  #Loop 2 : For running simulation for multiple values of l0
  i2=0
  while read alpha; do

    i2=`expr $i2 + 1`
    echo $i2

    > filename2.txt
    echo "sls$i2" >> filename2.txt

    #parameters change
      > para2.dat
      sed "9c$alpha" para.dat > para2.dat

    ./stoch_ls.x
    ./bp_sls.x
    ./statm.x

  done < alpha.dat
  #End loop 2

  #number of variants to be plotted together simultaneously
  echo $i2 > vari2.dat

  #To plot distributions
  gnuplot plot_dist_n.plt

  #To prepare data files for moments vs f0
  ./anlys_N.x

  #Remove directories if they already exist and recreate them
    rm -rf $line && mkdir $line

    mv sls*.dat $line
    mv dyn*.dat $line

    cp *.png $line

    cp plot_dist_n.plt $line

    cp nmotor.dat $line
    cp alpha.dat $line
    cp para.dat $line
    cp filen.dat $line
    cp pos.dat $line

    mv *_fpt.png FPT
    mv *_fptlg.png FPTLG
    mv *_runl.png RUNL
    mv *_sts.png STS
    mv *_stt.png STT
    mv *_sttlg.png STTLG
    mv *_vl.png VL
    mv *_uvsa.png UVSF

    mv $line $targ

    N=$(echo "$N + 1"|bc)

done
#End Loop 1

#To plot Statistical moments vs f0
gnuplot plot_anlys_n.plt

#To move all Distribution plots
mkdir $targ/Plots
mv FPT $targ/Plots
mv FPTLG $targ/Plots
mv RUNL $targ/Plots
mv STS $targ/Plots
mv STT $targ/Plots
mv STTLG $targ/Plots
mv VL $targ/Plots
mv UVSF $targ/Plots

# To move all Statistical plots and data
mkdir $targ/Stats
mv avg_*.dat $targ/Stats
mv rd_*.dat $targ/Stats
mv var_*.dat $targ/Stats
mv *.png $targ/Stats

# To remove executable files
rm *.x
