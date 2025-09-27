#!/bin/sh

##################################################
# Script to run a single simulation 
##################################################

#Compile the programs to be run :

  # Stochastic loadsharing programs
  gfortran stoch_ls.f95 mt_rng.f95 -o stoch_ls.x

  gfortran bp_sls.f95 -o bp_sls.x

  # Program for compiling Statistical quantities vs f0
  gfortran anlys_e.f95 -o anlys_e.x

# To run simulations and compile plots for multiple parameter values


  # To remove existing files and directories
  rm -rf avg_*.dat
  rm -rf rd_*.dat
  rm -rf var_*.dat
  rm -rf *.png

  rm -rf  FPT && mkdir  FPT
  rm -rf  RUNL && mkdir  RUNL
  rm -rf  UVSF && mkdir  UVSF


targ=Vary_N_lo55

rm -rf  $targ && mkdir $targ

j1=0
N=1

#Loop 1 : To loop over given values of f0 in the file
while [ "$j1" -lt 10 ];
do
  j1=$(( $j1 + 1 ))

  line=Mn_$j1
  echo $line > filen.dat
  echo $j > pos.dat

  #To modify parameter file to replace value for f0
  > para.dat
  sed '1c\'"$N"'' sim_para.dat > para.dat

  #Plot the unbinding rate curve
  ./uvsa.x
  gnuplot plot_uvsa.plt

  #Loop 2 : For running simulation for multiple values of l0
  i2=0
  while read alpha; do

    i2=`expr $i2 + 1`
    echo $i2

    > filename2.txt
    echo "sls$i2" >> filename2.txt

    #parameters change
      > para2.dat
      sed "10c$alpha" para.dat > para2.dat

    ./stoch_ls.x
    ./bp_sls.x

  done < alpha.dat
  #End loop 2

  #number of variants to be plotted together simultaneously
  echo $i2 > vari2.dat

  #To plot distributions
  gnuplot plot_dist_v.plt

  #To prepare data files for moments vs f0
  ./anlys_N.x

  #Remove directories if they already exist and recreate them
    rm -rf $line && mkdir $line

    mv sls*.dat $line
#    mv dyn*.dat $line

    cp *.png $line

    cp plot_dist_v.plt $line

  #  cp unbind.dat $line
    cp alpha.dat $line
    cp para.dat $line
    cp filen.dat $line
    cp pos.dat $line

    mv *_fpt.png FPT
    mv *_runl.png RUNL
    mv *_uvsa.png UVSF

    mv $line $targ

    N=$(( $N + 1 ))
done
#End Loop 1

#To plot Statistical moments vs f0
gnuplot plot_anlys_N.plt

#To move all Distribution plots
mkdir $targ/Plots
mv FPT $targ/Plots
mv RUNL $targ/Plots
mv UVSF $targ/Plots

# To move all Statistical plots and data
mkdir $targ/Stats
mv avg_*.dat $targ/Stats
mv *.png $targ/Stats

#Save parameters in file
cp param.dat $targ
cp binpara.dat $targ
cp alpha.dat $targ

# To remove executable files
rm *.x
