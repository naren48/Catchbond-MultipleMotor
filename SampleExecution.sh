#!/bin/sh

##################################################
# Script to run a single simulation 
##################################################

# Sample command : bash SampleExecution.sh <Nmotor> <pi> <eps>
# The rest of the parameters are fixed but can also be taken as user arguments



# To run simulations and compile plots for multiple parameter values

#Target directory to save all output files
TargetDirectory=Nmotor_$1-pi_$2-eps_$3
rm -rf  $TargetDirectory && mkdir $TargetDirectory

# Set up parameters in an input cofniguration file
Nmotor=$1
pi=$2
eps=$3
v0=1740
fs=1.1
alpha=40
Niter=1000

# Write parameters to input file for use
cp SimulationParams.conf $TargetDirectory/
cd $TargetDirectory

#Compile the programs to be run :
  # Stochastic loadsharing programs
mv SimulationParams.conf InputParams.conf
gfortran ../TransportSimulation.f95 ../MersenneTwister_RNG.f95 -o Transport.x

sed -i -e "s/Nmotor/${Nmotor}/g" InputParams.conf
sed -i -e "s/pi/${pi}/g" InputParams.conf
sed -i -e "s/eps/${eps}/g" InputParams.conf
sed -i -e "s/v0/${v0}/g" InputParams.conf
sed -i -e "s/fs/${fs}/g" InputParams.conf
sed -i -e "s/alpha/${alpha}/g" InputParams.conf
sed -i -e "s/Niter/${Niter}/g" InputParams.conf


#Execute the simulation :
./Transport.x

# To remove executable files
rm *.x
cd ..
