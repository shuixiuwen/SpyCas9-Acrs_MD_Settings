#!/bin/bash
# nohup bash run_pr.sh > run_pr.log 2>&1 &
# Intel
source /opt/intel/bin/compilervars.sh intel64
export MKL_HOME=/opt/intel/mkl

# Cuda
export PATH=/usr/local/cuda/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH

# Amber
export AMBERHOME=/opt/amber18
source $AMBERHOME/amber.sh

export CUDA_VISIBLE_DEVICES=0
INPUT=sys_sol

GPURUN="pmemd.cuda -O -p ${INPUT}.prmtop"


########################
# Production Run
########################
cat > pr.in << EOF
Production Run: heavy atoms of solutes restrained
 &cntrl
  imin=0, irest=1, ntx=5,
  nstlim=50000000, dt=0.002,
  ntwr=0, ntpr=1000, ntwx=1000, ntxo=2, ioutfm=1, iwrap=1,
  ntc=2, ntf=2,
  cut=9.0,
  ntt=3, gamma_ln=2.0, temp0=300.0, ig=-1,
  ntb=2, ntp=1, barostat=2, pres0=1.01325,
  ntr=1, restraint_wt=2.5, restraintmask='!:WAT & !@H=',
 /
EOF

$GPURUN -c eq1.rst -ref eq1.rst \
        -i pr.in -o pr1.out -r pr1.rst -x pr1.nc
