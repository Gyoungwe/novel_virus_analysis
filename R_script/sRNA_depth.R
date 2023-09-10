library(ggplot2)
setwd("Z:/2nature/novel_viruses/JPSH/sRNA_depth")
# 提供的文件前缀

prefix <- "virus5TRINITY_DN3931_c0_g1_i1"

# 读取正向深度数据
forward_depth_data <- read.table(paste0(prefix, "_forward.depth"), header = FALSE)

# 读取反向深度数据
reverse_depth_data <- read.table(paste0(prefix, "_reverse.depth"), header = FALSE)

# 合并深度数据，将负向的深度值变为负数
combined_depth_data <- rbind(forward_depth_data, transform(reverse_depth_data, V3 = -V3))

# 绘制图形
depth_plot <- ggplot(data = combined_depth_data, aes(x = V2, y = V3)) +
  geom_area(linetype = "solid", linewidth = 1, alpha = 1, color = "gray", fill = "lightgray")  +
  ylim(-300000, 300000) +  # 负向深度值取负数，所以取值范围为 -300000 到 300000
  xlab("Position") +   # 设置X轴标签
  ylab("Depth") +   # 设置Y轴标签 
  theme(
    panel.background = element_rect(fill = "white"),
    axis.text = element_text(family = "Arial", face = "bold", size = 20),  # 修改坐标轴标签的字体为Arial，加粗，大小为12
    axis.title = element_text(family = "Arial", face = "bold", size = 22)   # 修改坐标轴标题的字体为Arial，加粗，大小为14
  ) + 
  scale_y_continuous(expand = expansion(mult = c(0, 0.03)), breaks = seq(from = -300000, to = 300000, by = 100))  # 调整 y 轴刻度范围，使 y 轴从 0 开始

# 显示图形
print(depth_plot)
