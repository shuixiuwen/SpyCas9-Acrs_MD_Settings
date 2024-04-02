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

createcrd ALIGNED
run
crdaction ALIGNED average avg.pdb
parm avg.pdb
reference avg.pdb parm avg.pdb
crdaction ALIGNED rms reference :1-1369
crdaction ALIGNED matrix covar name COVAR :1-1369
runanalysis diagmatrix COVAR out 6ifo_covar.dat vecs 20 name EVECTORS
crdaction ALIGNED projection PROJ modes 6ifo_covar.dat beg 1 end 3 \
	out 6ifo_projection.dat :1-1369
hist PROJ:1 PROJ:2 bins 50 out hists_1-2.gnu name PC12 free 300
hist PROJ:1 PROJ:3 bins 50 out hists_1-3.gnu name PC13 free 300
hist PROJ:2 PROJ:3 bins 50 out hists_2-3.gnu name PC23 free 300
EOF
mv *dat *gnu 
