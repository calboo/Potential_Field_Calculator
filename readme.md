# Potential Field Calc

### Usage
The code can be run on a single machine. In this case use the following lines to compile and then simply run the job:

gfortran -O3 bootsik.f90

Alternatively you can run the code in parallel for improved runtimes.
To run the code in parallel on a HPC use the following lines to compile:

module load intel/2018.1
ifort -o bootsik -O3 -parallel bootsik.f90 -xHost

Then submit the job to a HPC cluster. Intel 2018 works well but other compilers that can auto parallelise may also work.
