#! /bin/bash
echo $(date +%F%n%T)
cd ../dynamics
cpptraj <<EOF
parm 4zt0.prmtop
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
rms first @CA
average crdset rmsf_average
run
rms ref rmsf_average @CA
atomicfluct out 4zt0_rmsf_rep1.dat @CA
EOF

cpptraj <<EOF
parm 4zt0.prmtop
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
rms first @CA
average crdset rmsf_average
run
rms ref rmsf_average @CA
atomicfluct out 4zt0_rmsf_rep2.dat @CA
EOF
mv *dat ../analysis
