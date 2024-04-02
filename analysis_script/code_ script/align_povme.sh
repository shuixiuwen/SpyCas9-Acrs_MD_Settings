#! /bin/sh

echo $(date +%F%n%T)

cd ../dynamics

cpptraj << EOF
parm 6ifo.prmtop
trajin pr_replia1_1.nc 1 last 100
trajin pr_replia1_2.nc 1 last 100
trajin pr_replia1_3.nc 1 last 100
trajin pr_replia1_4.nc 1 last 100
trajin pr_replia1_5.nc 1 last 100
trajin pr_replia1_6.nc 1 last 100
trajin pr_replia1_7.nc 1 last 100
trajin pr_replia1_8.nc 1 last 100
trajin pr_replia1_9.nc 1 last 100
trajin pr_replia1_10.nc 1 last 100
autoimage
align first
strip :WAT,MG,Na+,Cl-
trajout 6ifo_povme_align_rep1_gap100.pdb pdb
run
EOF

mv 6ifo_povme_align_rep1_gap100.pdb ../povme

cpptraj << EOF
parm 6ifo.prmtop
trajin pr_replia2_1.nc 1 last 100
trajin pr_replia2_2.nc 1 last 100
trajin pr_replia2_3.nc 1 last 100
trajin pr_replia2_4.nc 1 last 100
trajin pr_replia2_5.nc 1 last 100
trajin pr_replia2_6.nc 1 last 100
trajin pr_replia2_7.nc 1 last 100
trajin pr_replia2_8.nc 1 last 100
trajin pr_replia2_9.nc 1 last 100
trajin pr_replia2_10.nc 1 last 100
autoimage
align first
strip :WAT,MG,Na+,Cl-
trajout 6ifo_povme_align_rep2_gap100.pdb pdb
run
EOF

mv 6ifo_povme_align_rep2_gap100.pdb ../povme
