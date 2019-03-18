#!/bin/sh
#$ -cwd          
#$ -j y
#$ -V
#$ -m bea
#$ -M c.boocock@qmul.ac.uk
#$ -pe smp 32     # Request cores
#$ -l h_vmem=2G   # Request RAM

module purge
module load intel/2018.1

./bootsik
