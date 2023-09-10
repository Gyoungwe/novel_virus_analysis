import pysam

# 输入文件路径
bam_file = "/share/home/gaoyangwei/exercise/project/aphid_virus/step13d_jpsh_virus_bowtie/run3/JPSH_siRNA.sort.bam"
output_dir = "/share/home/gaoyangwei/exercise/project/aphid_virus/step13d_jpsh_virus_bowtie/run3/sRNA_peak/"
#reference_names = ["TRINITY_DN787_c0_g1_i1", "TRINITY_DN5_c0_g1_i1","TRINITY_DN66897_c0_g1_i1","TRINITY_DN3931_c0_g1_i1","TRINITY_DN9470_c0_g2_i4","TRINITY_DN84112_c0_g1_i1"]
reference_names = ["TRINITY_DN773_c0_g2_i1","TRINITY_DN773_c0_g1_i1"]
# 遍历参考序列名称列表
for reference_name in reference_names:

    # 输出文件路径
    output_file = f"{output_dir}{reference_name}.txt"
    base_counts_file = f"{output_dir}{reference_name}_base_counts.txt"

    # 统计长度在 18 到 30 之间的 sRNA 数量
    # 输入 bam 文件需要建立 index
    length_counts = {length: {"forward": 0, "reverse": 0} for length in range(18, 31)}

    # 初始化碱基计数器
    base_counts = {"A": {"forward": 0, "reverse": 0},
                   "G": {"forward": 0, "reverse": 0},
                   "C": {"forward": 0, "reverse": 0},
                   "T": {"forward": 0, "reverse": 0},
                   "U": {"forward": 0, "reverse": 0}}

    # 打开 BAM 文件
    with pysam.AlignmentFile(bam_file, "rb") as bam:

        # 遍历比对记录
        for read in bam.fetch():

            # 获取比对序列长度
            read_length = read.query_length

            # 获取参考序列名称
            reference_name_bam = bam.get_reference_name(read.reference_id)

            #判断参考序列名称并计算方向性
            #正义链病毒
            # if reference_name_bam == reference_name:
            #     if 18 <= read_length <= 30:
            #         if read.flag & 0x10:
            #             length_counts[read_length]["reverse"] += 1
            #
            #             # 获取前一个碱基
            #             previous_base = read.query_sequence[-1]  # 获取最后一个碱基
            #
            #             # 更新碱基计数
            #             base_counts[previous_base]["reverse"] += 1
            #
            #         else:
            #             length_counts[read_length]["forward"] += 1
            #
            #             # 获取前一个碱基
            #             previous_base = read.query_sequence[0]  # 获取最后一个碱基
            #
            #             # 更新碱基计数
            #             base_counts[previous_base]["forward"] += 1

            if reference_name_bam == reference_name:
                if 18 <= read_length <= 30:
                    if read.flag & 0x10:
                        length_counts[read_length]["forward"] += 1

                        # 获取前一个碱基
                        previous_base = read.query_sequence[0]  # 获取第一个碱基

                        # 更新碱基计数
                        base_counts[previous_base]["forward"] += 1

                    else:
                        length_counts[read_length]["reverse"] += 1

                        # 获取前一个碱基
                        previous_base = read.query_sequence[-1]  # 获取最后一个碱基

                        # 更新碱基计数
                        base_counts[previous_base]["reverse"] += 1
    # 将统计结果写入输出文件
    with open(output_file, "w") as f:
        for length, counts in length_counts.items():
            forward_count = counts["forward"]
            reverse_count = counts["reverse"]
            f.write(f"{length}\t{forward_count}\t{reverse_count} sRNA\n")

    # 将碱基计数结果写入另一个文件
    with open(base_counts_file, "w") as f:
        for base, counts in base_counts.items():
            forward_count = counts["forward"]
            reverse_count = counts["reverse"]
            f.write(f"{base}\t{forward_count}\t{reverse_count}\n")

    # 输出完成信息
    print(f"结果已保存到文件 {output_file} 和 {base_counts_file} 中。")
