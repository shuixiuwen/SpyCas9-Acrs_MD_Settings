#! /bin/sh

echo $(date +%F%n%T)
cd ../dynamics/

cpptraj << EOF
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
strip :WAT,MG,Na+,Cl-&!@H= outprefix OnlyUsefulAtoms
loadtraj name MyTraj
runanalysis cluster crd1 crdset MyTraj \
    dbscan minpoints 25 epsilon 0.9 sievetoframe \
    rms :1-1364@CA \
    sieve 10 random \
    out combined_cnumvtime.dat \
    sil Sil \
    summary summary.dat \
    info info.dat \
    cpopvtime cpopvtime.agr normframe \
    repout rep repfmt pdb
EOF
mv *.dat ../analysis

