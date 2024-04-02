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
nativecontacts name AcrIIA2_Res :1-1369&!@H= :1458-1579&!@H= \   
   writecontacts 6ifo_Res_NativeContacts.dat \   
   resout 6ifo_Res_resout.dat \   
   distance 5.0 \
   byresidue out 6ifo_Res_AllResidues.dat mindist maxdist \
   map mapout 6ifo_Res_Map.dat \
   contactpdb Res_Contactspdb.pdb \
   series seriesout 6ifo_Res_NativeContactSeries.dat

nativecontacts name AcrIIA2_CA :1-1369@CA :1458-1579@CA \   
   writecontacts 6ifo_CA_NativeContacts.dat \   
   resout 6ifo_CA_resout.dat \   
   distance 8.0 \
   mindist maxdist \
   map mapout 6ifo_CA_Map.dat \
   contactpdb CA_Contactspdb.pdb \
   series seriesout 6ifo_CA_NativeContactSeries.dat
EOF
mv *dat ../analysis
# [resout] File to write contact residue pairs to