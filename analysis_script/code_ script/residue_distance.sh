#! /bin/sh

echo $(date +%F%n%T)

cd ../dynamics/

cpptraj << EOF
parm 6ifo.prmtop
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
autoimage
strip :WAT,MG,Na+,Cl-&!@H=
distance endtoend :11 :841 out RvucToHnh_distance.dat
EOF