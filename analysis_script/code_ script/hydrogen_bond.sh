#! /bin/bash
echo $(date +%F%n%T)
cd ../../dynamics

#cpptraj <<EOF
#parm 6ifo.prmtop
#trajin pr1.nc
#trajin pr2.nc
#trajin pr3.nc
#trajin pr4.nc
#trajin pr5.nc
#trajin pr6.nc
#trajin pr7.nc
#trajin pr8.nc
#trajin pr9.nc
#trajin pr10.nc
#strip :WAT,MG,Na+,Cl-
#autoimage
#hbond contacts :1-1369,1458-1579 \
#out 6ifo_hbond_out.dat \
#avgout 6ifo_hbond_avg.dat \
#series uuseries 6ifo_hbond_uuseries.dat nointramol
#run
#lifetime contacts[solutehb] out 6ifo_hbond_contacts_lifetime.dat
#create contacts[UU] 6ifo_hbond_create_num.dat 
#EOF


cpptraj <<EOF
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
strip :WAT,MG,Na+,Cl-
autoimage
hbond contacts :1-1369,1458-1579 \
out 6ifo_hbond_out_rep1.dat \
avgout 6ifo_hbond_avg_rep1.dat \
series uuseries 6ifo_hbond_uuseries_rep1.dat nointramol
run
lifetime contacts[solutehb] out 6ifo_hbond_contacts_lifetime_rep1.dat
create contacts[UU] 6ifo_hbond_create_num_rep1.dat 
run
EOF


cpptraj <<EOF
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
strip :WAT,MG,Na+,Cl-
autoimage
hbond contacts :1-1369,1458-1579 \
out 6ifo_hbond_out_rep2.dat \
avgout 6ifo_hbond_avg_rep2.dat \
series uuseries 6ifo_hbond_uuseries_rep2.dat nointramol
run
lifetime contacts[solutehb] out 6ifo_hbond_contacts_lifetime_rep2.dat
create contacts[UU] 6ifo_hbond_create_num_rep2.dat 
run
EOF

mv *dat ../analysis/hbond_analysis
