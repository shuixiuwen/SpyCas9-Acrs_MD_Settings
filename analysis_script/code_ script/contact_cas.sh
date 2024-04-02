#! /bin/sh

echo $(date +%F%n%T)

cd ../../dynamics/

cpptraj << EOF
parm 6ifo.prmtop
trajin pr_replia1_1.nc
trajin pr_replia1_2.nc
trajin pr_replia1_3.nc
trajin pr_replia1_4.nc
trajin pr_replia1_5.nc
trajin pr_replia1_6.nc
trajin pr_replia1_7.nc
trajin pr_replia1_8.nc
trajin pr_replia1_9.nc
trajin pr_replia1_10.nc
autoimage
strip :WAT,MG,Na+,Cl-&!@H=
nativecontacts name AcrIIA2_cas_rep1 :1-1369@CA \   
   writecontacts 6ifo_cas_NativeContacts_rep1.dat \   
   resout 6ifo_cas_resout_rep1.dat \   
   distance 8.0 \
   byresidue out 6ifo_cas_AllResidues_rep1.dat mindist maxdist \
   map mapout 6ifo_cas_Map_rep1.dat \
   contactpdb cas_Contactspdb_rep1.pdb \
   series seriesout 6ifo_cas_NativeContactSeries_rep1.dat
EOF


cpptraj << EOF
parm 6ifo.prmtop
trajin pr_replia2_1.nc
trajin pr_replia2_2.nc
trajin pr_replia2_3.nc
trajin pr_replia2_4.nc
trajin pr_replia2_5.nc
trajin pr_replia2_6.nc
trajin pr_replia2_7.nc
trajin pr_replia2_8.nc
trajin pr_replia2_9.nc
trajin pr_replia2_10.nc
autoimage
strip :WAT,MG,Na+,Cl-&!@H=
nativecontacts name AcrIIA2_cas_rep2 :1-1369@CA \   
   writecontacts 6ifo_cas_NativeContacts_rep2.dat \   
   resout 6ifo_cas_resout_rep2.dat \   
   distance 8.0 \
   byresidue out 6ifo_cas_AllResidues_rep2.dat mindist maxdist \
   map mapout 6ifo_cas_Map_rep2.dat \
   contactpdb cas_Contactspdb_rep2.pdb \
   series seriesout 6ifo_cas_NativeContactSeries_rep2.dat
EOF


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
nativecontacts name AcrIIA2_cas :1-1369@CA \   
   writecontacts 6ifo_cas_NativeContacts.dat \   
   resout 6ifo_cas_resout.dat \   
   distance 8.0 \
   byresidue out 6ifo_cas_AllResidues.dat mindist maxdist \
   map mapout 6ifo_cas_Map.dat \
   contactpdb cas_Contactspdb.pdb \
   series seriesout 6ifo_cas_NativeContactSeries.dat
EOF

mv *dat cas_Contactspdb* ../analysis/contact_cas



