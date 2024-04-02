
import MDAnalysis as mda
import prolif as plf
import numpy as np
import os
import time

starTime =  time.time()
Output_name = '4un3_ppiData' 
fileDir = "/home/sxwen/spycas9-sgRNA-dsDNA/dynamics/"
saveDir = "/home/sxwen/spycas9-sgRNA-dsDNA/protein_interation"
workDir = os.chdir(fileDir)

# load traj
u = mda.Universe("test_4un3.prmtop", ["pr1.nc", "pr2.nc", "pr3.nc", 
    "pr4.nc", "pr5.nc", "pr6.nc", "pr7.nc", "pr8.nc", "pr9.nc", "pr10.nc"])
dsDNA = u.select_atoms("resid 1471:1481")
cas = u.select_atoms("resid 82:1442")

# prot-prot interactions
fp = plf.Fingerprint(
    [
        "HBDonor",
        "HBAcceptor",
        "PiStacking",
        "PiCation",
        "CationPi",
        "Anionic",
        "Cationic",
    ]
)

fp.run(u.trajectory[::10], dsDNA, cas)
df = fp.to_dataframe()
df.to_csv(os.path.join(saveDir, Output_name + ".csv"))

finishTime =  time.time()
print('Running time is %s Seconds' % (finishTime-starTime))





