#!/bin/bash
echo $(date +%F%n%T)

# Intel
source /opt/intel/bin/compilervars.sh intel64
export MKL_HOME=/opt/intel/mkl

# Amber
export AMBERHOME=/opt/amber20
source $AMBERHOME/amber.sh

# 生成相应top文件
#ante-MMPBSA.py -p 6ifo.prmtop -c 6ifo_complex.prmtop \
#	-r cas_receptor.prmtop -l acr_ligand.prmtop \
#	-s ":WAT,MG,Na+,Cl-" -n ":1443-1481"

########################
# MMPBSA_DECOMP
########################
cat > mmpbsa.in << EOF
Per-residue PB decomposition
&general
	startframe=1, endframe=10, interval=2, 
	verbose=1, keep_files=0, 
	debug_printlevel=1, 
/
&pb
	istrng=0.100,
	inp=2, radiopt=0,
	indi=1.0,
	exdi=78.5,
/
EOF

#&decomp
#	idecomp=1, print_res="1099-1368; 1458-1579", csv_format=0, 
#	dec_verbose=1, 
#/

#mpirun -np 4 MMPBSA.py.MPI -O -i mmpbsa.in \
#	-o 6ifo_totalEnergyChange_sgRNA_pb.dat -do 6ifo_decomposition_sgRNA_pb.dat \
#	-cp complex_sgRNA_pb.prmtop -rp cas_sgRNA_pb.prmtop -lp acr_pb.prmtop \
#	-sp 6ifo.prmtop \
#	-y ../dynamics/pr10.nc > mmpbsa_process.log

mpirun -np 4 MMPBSA.py.MPI -O -i mmpbsa.in \
       -o 6ifo_totalEnergyChange_sgRNA_pb_revise.dat \
       -cp complex_sgRNA_pb.prmtop -rp cas_sgRNA_pb.prmtop -lp acr_pb.prmtop \
       -sp 6ifo.prmtop \
       -y ../dynamics/pr10.nc > mmpbsa_process.log

