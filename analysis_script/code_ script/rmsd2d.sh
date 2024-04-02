#! /bin/bash
echo $(date +%F%n%T)
cd ../dynamics

cpptraj <<EOF
parm 5xbl.prmtop
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
strip !(:1-1364@CA)
autoimage
createcrd 5xbl_trajectories
run
rms2d crdset 5xbl_trajectories :1-1364@CA out 5xbl_2drms.dat
runanalysis
EOF