#! /bin/sh

echo $(date +%F%n%T)

cd ../dynamics/

cpptraj << EOF
parm 4un3.prmtop
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
rms rmsd :82-1442@CA first out 4un3_rmsd_fel.dat
radgyr gyration :82-1442@CA out 4un3_gyration.dat
hist rmsd gyration bins 50 out hists_rmsd.gnu name rmsd_rg free 300
EOF
mv *dat *gnu ../energy_landscape