import pysam

# 输入文件路径
bam_file = "/share/home/gaoyangwei/exercise/project/aphid_virus/step13d_jpsh_virus_bowtie/run2/JPSH_siRNA.sort.bam"
output_dir = "/share/home/gaoyangwei/exercise/project/aphid_virus/step13d_jpsh_virus_bowtie/run2/sRNA_bam/"
#reference_names = ["TRINITY_DN787_c0_g1_i1", "TRINITY_DN5_c0_g1_i1","TRINITY_DN66897_c0_g1_i1","TRINITY_DN3931_c0_g1_i1","TRINITY_DN9470_c0_g2_i4","TRINITY_DN84112_c0_g1_i1",
                   # "TRINITY_DN773_c0_g2_i1", "TRINITY_DN773_c0_g1_i1"]
reference_names = ["virus5TRINITY_DN3931_c0_g1_i1"]
# 遍历参考序列名称列表
for reference_name in reference_names:
    # 创建 BAM 文件对象
    with pysam.AlignmentFile(bam_file, "rb") as bam:
        # 输出文件路径
        forward_output_file = f"{output_dir}{reference_name}_forward.bam"
        reverse_output_file = f"{output_dir}{reference_name}_reverse.bam"

        # 创建两个 BAM 文件对象，一个用于保存正向序列，一个用于保存反向序列
        forward_bam = pysam.AlignmentFile(forward_output_file, "wb", header=bam.header)
        reverse_bam = pysam.AlignmentFile(reverse_output_file, "wb", header=bam.header)

        # 遍历比对记录
        for read in bam.fetch(reference=reference_name):
            if not read.flag & 0x10:  # 正向序列
                forward_bam.write(read)  # 将正向序列写入正向BAM文件
            else:  # 反向序列
                reverse_bam.write(read)  # 将反向序列写入反向BAM文件

        # 关闭 BAM 文件对象
        forward_bam.close()
        reverse_bam.close()

        # 输出完成信息
        print(f"结果已保存到文件 {forward_output_file} 和 {reverse_output_file} 中。")
