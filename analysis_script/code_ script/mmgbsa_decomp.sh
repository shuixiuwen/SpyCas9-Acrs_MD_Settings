#!/bin/bash
echo $(date +%F%n%T)

# Intel
source /opt/intel/bin/compilervars.sh intel64
export MKL_HOME=/opt/intel/mkl

# Amber
export AMBERHOME=/opt/amber20
source $AMBERHOME/amber.sh

# 生成相应top文件
#ante-MMPBSA.py -p 5xbl.prmtop -c 5xbl_complex.prmtop \
#	-r cas_receptor.prmtop -l acr_ligand.prmtop \
#	-s ":WAT,MG,Na+,Cl-" -n ":1443-1481"

source leaprc.protein.ff14SB
source leaprc.RNA.OL3
com = loadpdb 5xbl_fixed_deleteP.pdb
cas = loadpdb cas_sgRNA.pdb
acr = loadpdb acr.pdb 
set default PBRadii mbondi2
saveAmberParm com complex_gb.prmtop complex.inpcrd
saveAmberParm cas cas_gb.prmtop cas.inpcrd
saveAmberParm acr acr_gb.prmtop acr.inpcrd
quit

########################
# MMGBSA_DECOMP
########################
cat > mmgbsa.in << EOF
Per-residue GB decomposition
&general
	startframe=1, endframe=10000, interval=10, 
	verbose=1, keep_files=0, 
	debug_printlevel=1, 
/
&gb
	igb=5, saltcon=0.15,
/
&decomp
	idecomp=1, print_res="1-1364; 1365-1446", csv_format=0, 
	dec_verbose=1, 
/
EOF


mpirun -np 12 MMPBSA.py.MPI -O -i mmgbsa.in \
	-o 5xbl_totalEnergyChange.dat \
	-do 5xbl_decomposition_summary.dat \
	-cp complex_gb.prmtop \
	-rp cas_gb.prmtop \
	-lp acr_gb.prmtop \
	-sp 5xbl.prmtop \
	-y ../dynamics/pr10.nc > mmgbsa_process.log


mpirun -np 12 MMPBSA.py.MPI -O -i mmgbsa.in \
	-o 5xbl_totalEnergyChange_rep1.dat \
	-do 5xbl_decomposition_rep1.dat \
	-cp complex_gb.prmtop \
	-rp cas_gb.prmtop \
	-lp acr_gb.prmtop \
	-sp 5xbl.prmtop \
	-y ../dynamics/pr_replia1_10.nc > mmgbsa_process_rep1.log


mpirun -np 12 MMPBSA.py.MPI -O -i mmgbsa.in \
	-o 5xbl_totalEnergyChange_rep2.dat \
	-do 5xbl_decomposition_rep2.dat \
	-cp complex_gb.prmtop \
	-rp cas_gb.prmtop \
	-lp acr_gb.prmtop \
	-sp 5xbl.prmtop \
	-y ../dynamics/pr_replia2_10.nc > mmgbsa_process_rep2.log
echo $(date +%F%n%T)
