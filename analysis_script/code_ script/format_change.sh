#! /bin/bash
cpptraj <<EOF
parm ../4un3_onlyCA.prmtop
trajin 4un3_mode1.nc 
trajout 4un3_mode1.crd
EOF