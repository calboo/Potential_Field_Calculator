# Potential Field Calculator

## Purpose

This is a FORTRAN90 code that can be used to generate a potential magnetic field on a 3D mesh, staggered relative to the magnetic potential, by extrapolating the magnetic field normal to the photospheric surface. The code first calculates a magnetic potential using a modified Green’s function method and then uses a finite differencing scheme to calculate the magnetic field from the potential.

## Inputs

The input for this code is the magnetic field normal to the lower photospheric boundary. This can be either specified within the code itself or read in from an input file. There are examples of two analytically defined inputs in the code as well as a block that can be used to import data. The user can uncomment whichever Bz0 profile they want to use or alternatively specify their own Bz0 field.

If an analytic input is used then the parameters can be set in the module *constants*. If an input file is used the user should be careful to make sure that the size of the imported array is equal to the size of bz0 as defined in *constants*. There is an example input file *Bz0.dat* provided which has dimensions of nx=308, ny=308.

## Files




EQUATIONS  

### Usage
The code can be run on a single machine. In this case use the following lines to compile and then simply run the job:

gfortran -O3 bootsik.f90

Alternatively you can run the code in parallel for improved runtimes.
To run the code in parallel on a HPC use the following lines to compile:

module load intel/2018.1
ifort -o bootsik -O3 -parallel bootsik.f90 -xHost

Then submit the job to a HPC cluster. Intel 2018 works well but other compilers that can auto parallelise may also work.
