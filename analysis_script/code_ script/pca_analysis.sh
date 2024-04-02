#! /bin/bash

echo $(date +%F%n%T)
cd ../dynamics/

#Strip atoms(remain CA only) of trajectory files(82-1442)
cpptraj <<EOF
parm 4un3.prmtop
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
trajout 4un3_integrate.nc
autoimage
strip !@CA
trajout 4un3_onlyCA.nc
run
exit
EOF

# Strip atoms(remain CA only) of top files
cpptraj <<EOF
parm 4un3.prmtop
parmstrip !@CA
parmwrite out 4un3_onlyCA.prmtop
run
exit
EOF

cpptraj <<EOF
#生成平均结构,计算坐标的协方差矩阵
parm 4un3_onlyCA.prmtop
trajin 4un3_onlyCA.nc 
rms first @CA
average crdset 4un3_average
createcrd 4un3_trajectories
run
crdaction 4un3_trajectories rms ref 4un3_average @CA 
crdaction 4un3_trajectories matrix covar @CA name 4un3_covar \
    out 4un3_CovarMatrix.dat

#计算主成分和坐标映射
runanalysis diagmatrix 4un3_covar out 4un3_evecs.dat vecs 2 name myEvecs \ 
    nmwiz nmwizvecs 2 nmwizfile 4un3.nmd nmwizmask @CA
crdaction 4un3_trajectories projection out 4un3_pca.dat modes myEvecs \ 
    beg 1 end 2 @CA crdframes 1,last
EOF

# Step 3: Visualizing principal components
cpptraj <<EOF
clear all
readdata 4un3_evecs.dat name Evecs
parm 4un3_onlyCA.prmtop
runanalysis modes name Evecs trajout 4un3_mode1.nc \
    pcmin -100 pcmax 100 tmode 1 trajoutmask @CA trajoutfmt netcdf

runanalysis modes name Evecs trajout 4un3_mode2.nc \
    pcmin -100 pcmax 100 tmode 2 trajoutmask @CA trajoutfmt netcdf
EOF

mv *dat *nmd 4un3_mode1.nc 4un3_mode2.nc ../analysis
