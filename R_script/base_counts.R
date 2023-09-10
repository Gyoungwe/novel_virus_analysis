library(ggplot2)

# 设置工作路径
setwd("Z:/2nature/novel_viruses/JPSH/sRNA_peak")

# 文件名列表
file_names <- c("TRINITY_DN787_c0_g1_i1", "TRINITY_DN5_c0_g1_i1","TRINITY_DN66897_c0_g1_i1",
                "virus5",
                "TRINITY_DN773_c0_g2_i1","TRINITY_DN773_c0_g1_i1")

# 批量处理和输出图像
for (file_name in file_names) {
  # 构造完整的文件路径
  file_path <- paste0(file_name, "_base_counts.txt")
  
  # 读取数据
  data <- read.table(file_path, header = FALSE, col.names = c("Base", "Forward_Count", "Reverse_Count"))
  
  # 修改数据框，将第三列数据累加到第二列数据上
  data$Forward_Count <- data$Forward_Count + data$Reverse_Count
  
  # 绘制柱状图
 p <- ggplot(data, aes(x = Base)) +
    geom_bar(aes(y = Forward_Count, fill = "Forward"), stat = "identity", position = "stack", width = 0.6, color = "black", size = 0.5) +
    geom_bar(aes(y = Reverse_Count, fill = "Reverse"), stat = "identity", position = "stack", width = 0.6, color = "black", size = 0.5) +
    scale_fill_manual(values = c("Forward" = "#87CEFA", "Reverse" = "#98FB98")) +
    labs(x = "Base", y = "Count") +
    theme_minimal() +
    theme(
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      panel.border = element_blank(),
      axis.line = element_line(color = "black"),
      axis.text = element_text(family = "Arial", face = "bold", size = 20),  # 修改坐标轴标签的字体为Arial，加粗，大小为12
      axis.title = element_text(family = "Arial", face = "bold", size = 22),   # 修改坐标轴标题的字体为Arial，加粗，大小为14
      plot.title = element_text(size = 16, face = "bold"),
      plot.background = element_rect(fill = "white"),
      panel.background = element_rect(fill = "white"),
      plot.margin = margin(1, 1, 1, 1, "cm")
    ) +
    guides(fill = guide_legend(title = "Label", override.aes = list(color = c("#87CEFA", "#98FB98")), labels = c("Forward", "Reverse")))
  
  # 输出图像为SVG格式
  output_file <- paste0(file_name,"_base",".svg")
  ggsave(output_file, p, width = 840 / 96, height = 576 / 96, units = "in", dpi = 96)
  
  # 打印完成信息
  print(paste("图像已保存为", output_file))
}
