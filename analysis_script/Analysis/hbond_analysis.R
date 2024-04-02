library(ggplot2)
library(tidyverse)
library(ggalluvial)
library(xlsx)
library(ggsankey)
library(cols4all)
library(dplyr)
library(gridExtra)
library(egg)
devtools::install_github("thomasp85/patchwork")
library(patchwork)
dt = read.xlsx("4un3_hbond - ¸±±¾.xlsx", sheetName = "Sheet1")
head(dt)
df <- dt %>%
  make_long(Acceptor, Donor)
head(df)

df$node <- factor(df$node,levels = c(dt$Donor %>% unique()%>% rev(),
                                     dt$Acceptor %>% unique() %>% rev()))
library(shiny)
#c4a_gui()
mycol <- c4a('rainbow_wh_rd',35)
mycol2 <- sample(mycol,length(mycol)) 


dna <- ggplot(df, aes(x = x,
                     next_x = next_x,
                     node = node,
                     next_node = next_node,
                     fill = node,
                     label = node)) +
  scale_fill_manual(values = mycol) + 
  geom_sankey(flow.alpha = 0.5,
              flow.fill = 'grey', 
              flow.color = 'grey80', 
              node.fill = mycol2, 
              smooth = 5, 
              space = 0.8,
              width = 0.12) +  
  geom_sankey_text(size = 5 , 
                   space = 0.8,
                   color = "black")+ 
  theme_void() +
  theme(legend.position = 'none') +
  theme_sankey(base_size = 24)
dna

ggsave("4un3_hbond_.tiff", plot = dna,
       width = 30, height = 25, units = "cm", dpi = 300)
install.packages("sankeywheel")
library(sankeywheel)
