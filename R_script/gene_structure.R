library(ggplot2)
library(gggenes)
library(showtext)

showtext_auto()  # 启用showtext功能

# 在showtext模式下设置字体
font_add("Arial", regular = "C:/Windows/Fonts/arial.ttf")  # 请将"Arial.ttf"替换为Arial字体文件的路径
#virus1_1
data <- data.frame(
  molecule = c("virus1"),
  gene = c("RNA"),
  start = c(6102),
  end = c(1),
  strand = rep("reverse", 1)
)

subgenes <- data.frame(
  molecule = c("virus1"),
  gene = c("RDRP"),
  start = c(5973),
  end = c(109),
  strand = rep("reverse", 1)
)
#virus1_2
data <- data.frame(
  molecule = c("virus1"),
  gene = c("RNA2"),
  start = c(2490),
  end = c(1),
  strand = rep("reverse", 1)
)

subgenes <- data.frame(
  molecule = c("virus1"),
  gene = c("ORF"),
  start = c(2292),
  end = c(523),
  strand = rep("reverse", 1)
)
#virus3
data <- data.frame(
  molecule = c("virus3"),
  gene = c("virus3"),
  start = c(1),
  end = c(3411),
  strand = rep("forward", 1)
)

subgenes <- data.frame(
  molecule = c("virus3"),
  gene = c("ORF1"),
  start = c(31),
  end = c(3345),
  strand = rep("forward", 1)
)

#virus4
data <- data.frame(
  molecule = c("virus4"),
  gene = c("RNA1"),
  start = c(1),
  end = c(1616),
  strand = rep("forward", 1)
)

subgenes <- data.frame(
  molecule = c("virus4"),
  gene = c("RDRP"),
  start = c(98),
  end = c(1531),
  strand = rep("forward", 1)
)
data <- data.frame(
  molecule = c("virus4"),
  gene = c("RNA2"),
  start = c(1),
  end = c(1542),
  strand = rep("forward", 1)
)

subgenes <- data.frame(
  molecule = c("virus4"),
  gene = c("ORF"),
  start = c(84),
  end = c(1277),
  strand = rep("forward", 1)
)


#virus5
#ref_virus

data <- data.frame(
  molecule = c("PNVA"),
  gene = c("PNVA"),
  start = c(1),
  end = c(5003),
  strand = rep("forward", 1)
)

subgenes <- data.frame(
  molecule = c("PNVA","PNVA",),
  gene = c("LA-virus_coat","RDRP"),
  start = c(210,2867),
  end = c(1355,4276),
  strand = rep("forward", 2)
)  

data <- data.frame(
  molecule = c("virus5","virus5","virus5"),
  gene = c("segment1","segment2","segment3"),
  start = c(1,2222,2954),
  end = c(2232,2953,5050),
  strand = rep("forward", 3)
)

subgenes <- data.frame(
  molecule = c("virus5"),
  gene = c("LA-virus_coat","RDDP"),
  start = c(50,2951),
  end = c(1327,4213),
  strand = rep("forward", 5)
)
#virus5_merge

data <- data.frame(
  molecule = c("PNVA","virus5","virus5","virus5"),
  gene = c("PNVA","segment1","segment2","segment3"),
  start = c(1,1,2222,2954),
  end = c(5003,2232,2953,5050),
  strand = rep("forward", 4)
)

subgenes <- data.frame(
  molecule = c("PNVA","PNVA","virus5","virus5"),
  gene = c("LA-virus_coat","RDRP","LA-virus_coat","RDDP"),
  start = c(210,2867,50,2951),
  end = c(1355,4276,1327,4213),
  strand = rep("forward", 4)
)  



data <- data.frame(
  molecule = c("virus5_2"),
  gene = c("segment2"),
  start = c(1),
  end = c(2232),
  strand = rep("forward", 1)
)

subgenes <- data.frame(
  molecule = c("virus5_2"),
  gene = c("Coat"),
  start = c(50),
  end = c(1327),
  strand = rep("forward", 1)
)

gene_arrow_plot <- ggplot(data, aes(xmin = start, xmax = end, y = molecule, fill = gene, label = gene)) +
  geom_gene_arrow(arrowhead_height = unit(3, "mm"), arrowhead_width = unit(1.5, "mm")) +
  geom_gene_label(label_fontsize = 20) +  # 设置基因标签的字体大小为20
  xlim(0, 3500) + 
  geom_gene_arrow(
    aes(xmin = start, xmax = end, y = molecule, fill = gene, label = gene),
    data = subgenes, subgene = TRUE, arrowhead_height = unit(3, "mm"),
    arrowhead_width = unit(1.5, "mm"), size = 0.3
  ) +
  facet_wrap(~ molecule, scales = "free", ncol = 1) +
  scale_fill_brewer(palette = "Set3") + 
  theme_genes() +
  theme(
    text = element_text(family = "Arial"),    # 设置字体为Arial
    axis.text = element_text(size = 20),      # 设置坐标轴标签的字体大小为20
    axis.title = element_text(size = 22),     # 设置坐标轴标题的字体大小为22
    legend.text = element_text(size = 20),    # 设置图例文本的字体大小为20
    legend.title = element_text(size = 20),   # 设置图例标题的字体大小为20
    strip.text = element_text(size = 22)      # 设置分面标签的字体大小为22
  )
#Pattel1 Set3

print(gene_arrow_plot)



#palette=Pastel1,Dark2
depth_data <- read.table("Z:/2nature/novel_viruses/JPSH/virus_depth/virus3.depth", header = FALSE)

depth_plot <- ggplot(data = depth_data, aes(x = V2, y = V3)) +
  geom_area(linetype = "solid", linewidth = 1, alpha = 1, color = "gray", fill = "lightgray") + xlim(0, 3500) +
  ylim(0, 300000) +
  xlab("Position") +   # 设置X轴标签
  ylab("Depth") +   # 设置Y轴标签 
  theme(
    panel.background = element_rect(fill = "white"),
    axis.text = element_text(family = "Arial", face = "bold", size = 20),  # 修改坐标轴标签的字体为Arial，加粗，大小为12
    axis.title = element_text(family = "Arial", face = "bold", size = 22)   # 修改坐标轴标题的字体为Arial，加粗，大小为14
  ) + 
  scale_y_reverse()


print(depth_plot)

gene_arrow_plot / depth_plot
