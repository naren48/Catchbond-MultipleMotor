## Multiple Motor Driven Transport of Cargo : 
The code in this repository is used to perform kinetic Monte Carlo simulations of cargo transport by multiple motor proteins. The motor proteins are modeled as springs with one end that performs stochastic uni-directional motion on a filament and the other attached to cargo. The FORTRAN code in this repository specifically models the cargo being constrained by a hookean spring force that increases linearly as the cargo moves away from the trap center. The dynamics is based on the stochastic load-sharing algorithm proposed in [Kunwar and Mogilner (2010)](https://iopscience.iop.org/article/10.1088/1478-3975/7/1/016012). The catch-bond force response of the motors is implemented according to the threshold force bond-deofrmation model proposed in [Nair et al 2016](https://journals.aps.org/pre/abstract/10.1103/PhysRevE.94.032403).

The code implementation is in FORTRAN 95 and requires the gfortran compiler that can be installed in a linux terminal by 

`sudo apt install gfortran`

The random number generator attached in mt_rng.f95 is a Mersenne Twister based random number generator to facilitate random number generations with a large periodicity (2^19937). A sample bash script to execute the program is attached in the repository. 


The primary results of this model are Published in [Sundararajan et al(2024)](https://pubs.rsc.org/en/content/articlelanding/2024/sm/d3sm01122d/unauth). 
