#! /bin/sh
#gmx trjconv -s 4un3_gmx_select.gro -f 4un3_gmx.xtc -o  4un3_gmx_revise.xtc -fit rot+trans
gmx << EOF
rms -s 4un3_gmx_select.gro -f 4un3_gmx_revise.xtc -o 4un3_rmsd.xvg
gyrate -s 4un3_gmx_select.gro -f 4un3_gmx_revise.xtc -o 4un3_gyrate.xvg
EOF
gmx sham -tsham 300 -nlevels 100 -f output.xvg -ls gibbs.xpm -g gibbs.log \
	-lsh enthalpy.xpm -lss entropy.xpm

-tsham ：设定温度
-nlevels：设定FEL的层次数量
-f : 读入组合文件
-ls : 输出自由能形貌图（Gibbs自由能）
-g ：输出log文件
-lsh : 焓的形貌图
-lss : 熵的形貌图