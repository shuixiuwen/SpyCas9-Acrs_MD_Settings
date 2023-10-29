#!/bin/bash
# nohup bash run_md.sh > run_md.log 2>&1 &

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
INPUT=4un3

CPURUN="mpirun -genv I_MPI_DEVICE shm -n ${NCORES} pmemd.MPI -O -p ${INPUT}.prmtop"
GPURUN="pmemd.cuda -O -p ${INPUT}.prmtop"


########################
# Minimization Step 1
########################
cat > min1.in << EOF
Minimization Step 1: heavy atoms of solutes restrained
 &cntrl
  imin=1, maxcyc=2500, ncyc=1000,
  ntwr=0, ntpr=100, ntxo=2, ioutfm=1,
  ntc=1, ntf=1,
  cut=9.0,
  ntb=1,
  ntr=1, restraint_wt=10.0, restraintmask='!:WAT & !@H=',
 /
EOF

echo "Start Minimization Step 1"

$CPURUN -c ${INPUT}.inpcrd -ref ${INPUT}.inpcrd \
        -i min1.in -o min1.out -r min1.rst


########################
# Minimization Step 2
########################
cat > min2.in << EOF
Minimization Step 2: backbone atoms restrained
 &cntrl
  imin=1, maxcyc=2500, ncyc=1000,
  ntwr=0, ntpr=100, ntxo=2, ioutfm=1,
  ntc=1, ntf=1,
  cut=9.0,
  ntb=1,
  ntr=1, restraint_wt=10.0, restraintmask='@CA,C,O,N',
 /
EOF

echo "Start Minimization Step 2"

$CPURUN -c min1.rst -ref min1.rst \
        -i min2.in -o min2.out -r min2.rst


########################
# Minimization Step 3
########################
cat > min3.in << EOF
Minimization Step 3: no atoms restrained
 &cntrl
  imin=1, maxcyc=5000, ncyc=1000,
  ntwr=0, ntpr=100, ntxo=2, ioutfm=1,
  ntc=1, ntf=1,
  cut=9.0,
  ntb=1,
  ntr=0,
 /
EOF

echo "Start Minimization Step 3"

$CPURUN -c min2.rst \
        -i min3.in -o min3.out -r min3.rst


########################
# Heating
########################
cat > heat.in << EOF
Heating: backbone atoms restrained
 &cntrl
  imin=0, irest=0, ntx=1,
  nstlim=25000, dt=0.002,
  ntwr=0, ntpr=1000, ntwx=1000, ntxo=2, ioutfm=1,
  ntc=2, ntf=2,
  cut=9.0,
  ntt=3, gamma_ln=2.0, tempi=0.0, temp0=300.0, ig=-1,
  ntb=1, ntp=0,
  ntr=1, restraint_wt=5.0, restraintmask='@CA,C,O,N',
  nmropt=1,
 /
 &wt
  TYPE='TEMP0',
  istep1=0, istep2=25000,
  value1=0.1, value2=300.0,
 /
 &wt
  TYPE='END',
 /
EOF

echo "Start Heating"

$GPURUN -c min3.rst -ref min3.rst \
        -i heat.in -o heat.out -r heat.rst -x heat.nc


########################
# Equilibration Step 1
########################
cat > eq1.in << EOF
Equilibration Step 1: backbone atoms restrained
 &cntrl
  imin=0, irest=1, ntx=5,
  nstlim=100000, dt=0.002,
  ntwr=0, ntpr=2500, ntwx=2500, ntxo=2, ioutfm=1,
  ntc=2, ntf=2,
  cut=9.0,
  ntt=3, gamma_ln=2.0, temp0=300.0, ig=-1,
  ntb=2, ntp=1, barostat=1, taup=1.0, pres0=1.01325,
  ntr=1, restraint_wt=5.0, restraintmask='@CA,C,O,N',
 /
EOF

echo "Start Equilibration Step 1"

$GPURUN -c heat.rst -ref heat.rst \
        -i eq1.in -o eq1.out -r eq1.rst -x eq1.nc


########################
# Equilibration Step 2
########################
cat > eq2.in << EOF
Equilibration Step 2: backbone atoms restrained
 &cntrl
  imin=0, irest=1, ntx=5,
  nstlim=100000, dt=0.002,
  ntwr=0, ntpr=2500, ntwx=2500, ntxo=2, ioutfm=1,
  ntc=2, ntf=2,
  cut=9.0,
  ntt=3, gamma_ln=2.0, temp0=300.0, ig=-1,
  ntb=2, ntp=1, barostat=1, taup=1.0, pres0=1.01325,
  ntr=1, restraint_wt=1.0, restraintmask='@CA,C,O,N',
 /
EOF

echo "Start Equilibration Step 2"

$GPURUN -c eq1.rst -ref eq1.rst \
        -i eq2.in -o eq2.out -r eq2.rst -x eq2.nc


########################
# Equilibration Step 3
########################
cat > eq3.in << EOF
Equilibration Step 3: backbone atoms restrained
 &cntrl
  imin=0, irest=1, ntx=5,
  nstlim=100000, dt=0.002,
  ntwr=0, ntpr=2500, ntwx=2500, ntxo=2, ioutfm=1,
  ntc=2, ntf=2,
  cut=9.0,
  ntt=3, gamma_ln=2.0, temp0=300.0, ig=-1,
  ntb=2, ntp=1, barostat=1, taup=1.0, pres0=1.01325,
  ntr=1, restraint_wt=0.1, restraintmask='@CA,C,O,N',
 /
EOF

echo "Start Equilibration Step 3"

$GPURUN -c eq2.rst -ref eq2.rst \
        -i eq3.in -o eq3.out -r eq3.rst -x eq3.nc


########################
# Production Run
########################
cat > pr.in << EOF
Production: no atoms restrained
 &cntrl
  imin=0, irest=1, ntx=5,
  nstlim=50000000, dt=0.002,
  ntwr=0, ntpr=5000, ntwx=5000, ntxo=2, ioutfm=1,
  ntc=2, ntf=2,
  cut=9.0,
  ntt=3, gamma_ln=1.0, temp0=300.0, ig=-1,
  ntb=2, ntp=1, barostat=2, pres0=1.01325,
  ntr=0,
 /
EOF

nstart=1
nstop=5

for (( i=$nstart; i<=$nstop; i++ )); do

    echo "Start Production Run $i"

    if [ $i -eq 1 ]; then
        lastrun=eq3
    else
        lastrun=pr$(( $i - 1 ))
    fi

    $GPURUN -c ${lastrun}.rst \
            -i pr.in -o pr${i}.out -r pr${i}.rst -x pr${i}.nc

done

