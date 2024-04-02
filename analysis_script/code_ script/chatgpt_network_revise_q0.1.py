import numpy as np
import pandas as pd

import networkx as nx

sheets = pd.read_excel("Data_ToDraw_networkX_all_5A.xlsx", sheet_name = None,
    usecols=['distance','residue_x', 'residue_y'])

with pd.ExcelWriter("modularity_community_Q0.1.xlsx") as writer:
    for sheet_name, sheet_data in sheets.items():
        G=nx.Graph()
        for i in range(len(sheet_data)):
            node = sheet_data.loc[i,:][1] 
            next_node = sheet_data.loc[i,:][2]
            weight = sheet_data.loc[i,:][0]
            G.add_weighted_edges_from([(node,next_node,weight)])

        # 使用Girvan-Newman算法进行社区检测
        communities = list(nx.algorithms.community.girvan_newman(G))

    
        # 计算每种社区划分对应的模块度值(设置分辨率小于1)
        modularity_values_min = []
        for community in communities:
            modularity_value = nx.algorithms.community.quality.modularity(G, 
                community, resolution = 0.1) # type: ignore
            modularity_values_min.append(modularity_value)


        # 选择模块度最大的社区划分
        lessQ_com = communities[np.argmax(modularity_values_min)]

        df_min = pd.DataFrame({'Modularity': modularity_values_min})

        # 将模块度最大的社区输出到excel文件中
        lessQ_community_df = pd.DataFrame()
        for i, community in enumerate(lessQ_com):
            lessQ_community_df['Community %d' % (i+1)] = pd.Series(list(community))
        
        df_min.to_excel(writer,sheet_name = sheet_name + "_modularity_0.1", index=False)
        lessQ_community_df.to_excel(writer,sheet_name = "com_" + sheet_name, index=False)