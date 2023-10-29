#! /bin/bash
echo $(date +%F%n%T)

# Intel
source /opt/intel/bin/compilervars.sh intel64
export MKL_HOME=/opt/intel/mkl

# Cuda
export PATH=/usr/local/cuda/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH

# Amber
export AMBERHOME=/opt/amber20
source $AMBERHOME/amber.sh

export CUDA_VISIBLE_DEVICES=1
INPUT=4zt0

GPURUN="pmemd.cuda -O -p ${INPUT}.prmtop"

nstart=1
nstop=10

for (( i=$nstart; i<=$nstop; i++ )); do

    echo "Start Production Run $i"

    if [ $i -eq 1 ]; then
        lastrun=eq3
    else
        lastrun=pr_replia1_$(( $i - 1 ))
    fi

    $GPURUN -c ${lastrun}.rst \
            -i pr.in -o pr_replia1_${i}.out -r pr_replia1_${i}.rst -x pr_replia1_${i}.nc

done

