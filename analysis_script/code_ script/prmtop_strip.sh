#! /bin/sh

echo $(date +%F%n%T)

cd ../dynamics

cpptraj << EOF
parm 4un3.prmtop
parmstrip :WAT,MG,Na+,Cl-
parmwrite out com.prmtop
run
quit
EOF
mv com.prmtop ../mmpbsa