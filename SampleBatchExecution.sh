#!/bin/sh

##################################################
# Script to run a batch of simulation parameters : 
##################################################

# Sample command : bash SampleBatchExecution.sh
# The rest of the parameters are fixed but can also be taken as user arguments
# This script calls SampleExecution.sh for different parameter values : Nmotor, pi, eps
for N in 2 3 4 
do
    for pi in 0.1 1.0 10.0
    do
        for eps in 0.1 1.0 10.0
        do
            bash SampleExecution.sh $N $pi $eps
        done
    done
done