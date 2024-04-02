#!/bin/bash
# nohup bash run_eq.sh > run_eq.log 2>&1 &
# Intel
source /opt/intel/bin/compilervars.sh intel64
export MKL_HOME=/opt/intel/mkl

# Cuda
export PATH=/usr/local/cuda/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH

# Amber
export AMBERHOME=/opt/amber20
source $AMBERHOME/amber.sh

export CUDA_VISIBLE_DEVICES=0
NCORES=8
INPUT=sys_sol

CPURUN="mpirun -genv I_MPI_DEVICE shm -n ${NCORES} pmemd.MPI -O -p ${INPUT}.prmtop"
GPURUN="pmemd.cuda -O -p ${INPUT}.prmtop"



########################
# Minimization Step 1
########################
cat > min1.in << EOF
Minimisation step 1:heavy atoms of protein restrained
 &cntrl
  imin=1, maxcyc=2000, ncyc=2000,
  ntwr=0, ntpr=100, ntxo=2, ioutfm=1, iwrap=1,
  ntc=1, ntf=1,
  cut=9.0,
  ntb=1,
  ntr=1, restraint_wt=0.5, restraintmask='!@H=',
 /
EOF

$CPURUN -O -c ${INPUT}.inpcrd -ref ${INPUT}.inpcrd \
        -i min1.in -o min1.out -r min1.rst


########################
# Minimization Step 2
########################
cat > min2.in << EOF
Minimization Step 2: heavy atoms of solutes restrained
 &cntrl
  imin=1, maxcyc=10000, ncyc=2000,
  ntwr=0, ntpr=100, ntxo=2, ioutfm=1, iwrap=1,
  ntc=1, ntf=1,
  cut=9.0,
  ntb=1,
  ntr=1, restraint_wt=0.5, restraintmask='!:WAT & !@H=',
 /
EOF

$CPURUN -O -c min1.rst -ref min1.rst \
        -i min2.in -o min2.out -r min2.rst


########################
# Heating
########################
cat > heat.in << EOF
Heating: heavy atoms of solutes restrained
 &cntrl
  imin=0, irest=0, ntx=1,
  nstlim=25000, dt=0.002,
  ntwr=0, ntpr=1000, ntwx=1000, ntxo=2, ioutfm=1, iwrap=1,
  ntc=2, ntf=2,
  cut=9.0,
  ntt=3, gamma_ln=2.0, tempi=0.0, temp0=300.0, ig=-1,
  ntb=1, ntp=0,
  ntr=1, restraint_wt=25.0, restraintmask='!:WAT & !@H=',
  nmropt=1,
 /
 &wt
  TYPE='TEMP0',
  istep1=0, istep2=15000,
  value1=0.1, value2=300.0,
 /
 &wt
  TYPE='END',
 /
EOF

$CPURUN -O -c min2.rst -ref min2.rst \
        -i heat.in -o heat.out -r heat.rst -x heat.nc


########################
# Equilibration Step 
########################
cat > equilibration.in << EOF
Equilibration Step: heavy atoms of solutes restrained
 &cntrl
  imin=0, irest=1, ntx=5,
  nstlim=250000, dt=0.002,
  ntwr=0, ntpr=1000, ntwx=1000, ntxo=2, ioutfm=1, iwrap=1,
  ntc=2, ntf=2,
  cut=9.0,
  ntt=3, gamma_ln=2.0, temp0=300.0, ig=-1,
  ntb=2, ntp=1, barostat=1, taup=1.0, pres0=1.01325,
  ntr=1, restraint_wt=2.5, restraintmask='!:WAT & !@H=',
 /
EOF

$GPURUN -O -c heat.rst -ref heat.rst \
        -i equilibration.in -o equilibration.out -r equilibration.rst -x equilibration.nc


########################
# Simulation Run
########################
cat > simulation.in << EOF
Simulation Run: heavy atoms of solutes restrained
 &cntrl
  imin=0, irest=1, ntx=5,
  nstlim=5000000, dt=0.002,
  ntwr=0, ntpr=1000, ntwx=1000, ntxo=2, ioutfm=1, iwrap=1,
  ntc=2, ntf=2,
  cut=9.0,
  ntt=3, gamma_ln=2.0, temp0=300.0, ig=-1,
  ntb=2, ntp=1, barostat=2, pres0=1.01325,
  ntr=1, restraint_wt=2.5, restraintmask='!:WAT & !@H=',
 /
EOF

$GPURUN -O -c equilibration.rst -ref equilibration.rst \
        -i simulation.in -o simulation.out -r simulation.rst -x simulation.nc
