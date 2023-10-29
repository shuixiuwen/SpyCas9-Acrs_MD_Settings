#! /bin/bash
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
NCORES=6
INPUT=4zt0

#CPURUN="mpirun -genv I_MPI_DEVICE shm -n ${NCORES} pmemd.MPI -O -p ${INPUT}.prmtop"
GPURUN="pmemd.cuda -O -p ${INPUT}.prmtop"

nstart=9
nstop=10

for (( i=$nstart; i<=$nstop; i++ )); do

    echo "Start Production Run $i"

    if [ $i -eq 9 ]; then
        lastrun=pr8
    else
        lastrun=pr$(( $i - 1 ))
    fi

    $GPURUN -c ${lastrun}.rst \
            -i pr.in -o pr${i}.out -r pr${i}.rst -x pr${i}.nc

done
