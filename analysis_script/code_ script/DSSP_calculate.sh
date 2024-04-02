#! /bin/sh

echo $(date +%F%n%T)

cd ../../dynamics_2/

cpptraj << EOF
parm 4zt0.prmtop
trajin pr1.nc
trajin pr2.nc
trajin pr3.nc
trajin pr4.nc
trajin pr5.nc
trajin pr6.nc
trajin pr7.nc
trajin pr8.nc
trajin pr9.nc
trajin pr10.nc
strip :WAT,MG,Na+,Cl-&!@H=
autoimage
secstruct :1-1364 out 4zt0_dssp.gnu \ 
	sumout 4zt0_dssp_sumout.dat \
	assignout 4zt0_dssp_assignout.dat
EOF

mv *gnu *dat ../analysis/dssp

