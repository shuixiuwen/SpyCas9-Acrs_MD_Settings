import os
import numpy as np
import pytraj as pt
import matplotlib.pyplot as plt
import pandas as pd
import seaborn as sb
from statistics import mean, stdev
from pytraj import matrix
from matplotlib import colors
import warnings
warnings.filterwarnings('ignore', category=DeprecationWarning)
# load pytraj

Output_name = '4zt0_cc_pytraj' 

fileDir = "/home/sxwen/spycas9-sgRNA/dynamics_2/"
saveDir = "/home/sxwen/pytraj_analysis/cc_analysis"
workDir = os.chdir(fileDir)
# load trajectory to memory
traj = pt.iterload(["pr1.nc","pr2.nc","pr3.nc","pr4.nc","pr5.nc","pr6.nc",
   "pr7.nc","pr8.nc","pr9.nc","pr10.nc"], "4zt0.prmtop", mask = "@CA")
traj_align = pt.align(traj, mask='@CA', ref=0)

mat_cc = matrix.correl(traj_align, '@CA')

plt.switch_backend('agg')
ax = plt.imshow(mat_cc, cmap = 'PiYG_r', interpolation = 'bicubic', 
    vmin = -1, vmax = 1, origin='lower')

plt.xlabel('Residues', fontsize = 14, fontweight = 'bold')
plt.ylabel('Residues', fontsize = 14, fontweight = 'bold')
plt.xticks(fontsize = 12)
plt.yticks(fontsize = 12)
plt.title("sgRNA", fontsize = 14)
cbar1 = plt.colorbar()
cbar1.set_label('$CC_ij$', fontsize = 14, fontweight = 'bold', loc = 'top')

plt.savefig(os.path.join(saveDir, Output_name + ".png"), dpi=600, bbox_inches='tight')

raw_data=pd.DataFrame(mat_cc)
raw_data.to_csv(os.path.join(saveDir, Output_name + ".csv"))
