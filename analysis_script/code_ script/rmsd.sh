#! /bin/bash
echo $(date +%F%n%T)
#Caculate RMSD of 6ifo
cd ../dynamics/
cpptraj <<EOF
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
rms ToFirst :1-1369@CA first out 6ifo_rmsd_noAcr.dat
run
exit
EOF

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
autoimage
rms ToFirst :1-1369@CA first out 6ifo_rmsd_noAcr_rep1.dat
run
exit
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
autoimage
rms ToFirst :1-1369@CA first out 6ifo_rmsd_noAcr_rep2.dat
run
exit
EOF

