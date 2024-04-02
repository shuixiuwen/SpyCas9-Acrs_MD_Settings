
import MDAnalysis as mda
import prolif as plf
import numpy as np
import os
import networkx as nx
from pyvis.network import Network
from matplotlib import cm, colors
from IPython.display import IFrame
os.chdir("/home/sxwen/spycas9-sgRNA-dsDNA/dynamics/")
# load traj
u = mda.Universe("test_4un3.prmtop", "pr1.nc")
lig = u.select_atoms("resid 1471:1481")
prot = u.select_atoms("resid 82:1442")
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
fp.run(u.trajectory[::5000], lig, prot)
df = fp.to_dataframe()
print(df.head())

# 定义图
def make_graph(
    values,
    df=None,
    node_color=["#FFB2AC", "#ACD0FF"],
    node_shape="dot",
    edge_color="#a9a9a9",
    width_multiplier=1,
):
    """Convert a pandas DataFrame to a NetworkX object

    Parameters
    ----------
    values : pandas.Series
        Series with 'ligand' and 'protein' levels, and a unique value for
        each lig-prot residue pair that will be used to set the width and weigth
        of each edge. For example:

            ligand  protein
            LIG1.G  ALA216.A    0.66
                    ALA343.B    0.10

    df : pandas.DataFrame
        DataFrame obtained from the fp.to_dataframe() method
        Used to label each edge with the type of interaction

    node_color : list
        Colors for the ligand and protein residues, respectively

    node_shape : str
        One of ellipse, circle, database, box, text or image, circularImage,
        diamond, dot, star, triangle, triangleDown, square, icon.

    edge_color : str
        Color of the edge between nodes

    width_multiplier : int or float
        Each edge's width is defined as `width_multiplier * value`
    """
    lig_res = values.index.get_level_values("ligand").unique().tolist()
    prot_res = values.index.get_level_values("protein").unique().tolist()

    G = nx.Graph()
    # add nodes
    # https://pyvis.readthedocs.io/en/latest/documentation.html#pyvis.network.Network.add_node
    for res in lig_res:
        G.add_node(
            res, title=res, shape=node_shape, color=node_color[0], dtype="ligand"
        )
    for res in prot_res:
        G.add_node(
            res, title=res, shape=node_shape, color=node_color[1], dtype="protein"
        )

    for resids, value in values.items():
        label = "{} - {}<br>{}".format(
            *resids,
            "<br>".join(
                [
                    f"{k}: {v}"
                    for k, v in (
                        df.xs(resids, level=["ligand", "protein"], axis=1)
                        .sum()
                        .to_dict()
                        .items()
                    )
                ]
            ),
        )
        # https://pyvis.readthedocs.io/en/latest/documentation.html#pyvis.network.Network.add_edge
        G.add_edge(
            *resids,
            title=label,
            color=edge_color,
            weight=value,
            width=value * width_multiplier,
        )

    return G


# remove interactions between residues i and i±4 or less
mask = []
for l, p, interaction in df.columns:
    lr = plf.ResidueId.from_string(l)
    pr = plf.ResidueId.from_string(p)
    if (pr == lr) or (
        abs(pr.number - lr.number) <= 4
        and interaction in ["HBDonor", "HBAcceptor", "Hydrophobic"]
    ):
        mask.append(False)
    else:
        mask.append(True)
df = df[df.columns[mask]]
print(df.head())

# Plot Residue interaction network
data = (
    df.groupby(level=["ligand", "protein"], axis=1, sort=False)
    .sum()
    .astype(bool)
    .mean()
)

G = make_graph(data, df, width_multiplier=5)

# color each node based on its degree
max_nbr = len(max(G.adj.values(), key=lambda x: len(x)))
palette = cm.get_cmap("YlGnBu", max_nbr)
for n, d in G.nodes(data=True):
    n_neighbors = len(G.adj[n])
    d["color"] = colors.to_hex(palette(n_neighbors / max_nbr))

# convert to pyvis network
net = Network(width=640, height=500, notebook=True, heading="")
net.from_nx(G)

# use specific layout
layout = nx.circular_layout(G)
for node in net.nodes:
    node["x"] = layout[node["id"]][0] * 1000
    node["y"] = layout[node["id"]][1] * 1000
net.toggle_physics(False)

net.write_html("residue-network_graph.html")
IFrame("residue-network_graph.html", width=650, height=510)

