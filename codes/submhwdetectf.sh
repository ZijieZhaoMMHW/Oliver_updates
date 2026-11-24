#!/bin/bash
 
#PBS -l ncpus=1
#PBS -l mem=7GB
#PBS -l jobfs=3GB
#PBS -q normal
#PBS -P ng72
#PBS -l walltime=8:00:00
#PBS -l storage=gdata/rt52+scratch/rt52+gdata/w40+scratch/w40+gdata/v45+scratch/v45+gdata/gb6+gdata/ia39+gdata/ng72+scratch/ng72
#PBS -l wd
#PBS -l software=matlab_utas
  
module load matlab/R2020b
module load matlab_licence/utas

matlab -nodisplay -nosplash < mhwdetectffiles.m