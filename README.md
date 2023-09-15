# Novel_virus_analyse
The raw data used for this analysis can be downloaded from NCBI(...url...), and the intermediate files can be found on Zonodo.

  [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.8337333.svg)](https://doi.org/10.5281/zenodo.8337333)
## Step1 We assembled the chloroplast genome using `GetOrganelle` version (1.7.7.0)
```
#Maximum number of reads to be used per file
--max-reads inf
#Soft bound for maximum number of reads to be used according to target-hitting base coverage
--reduce-reads-for-coverage inf 
```
	
```
get_organelle_from_reads.py -1 JPSH_1.fq.gz -2 JPSH_2.fq.gz -t 96 -o JPSH.plastome.deep -F embplant_pt -R 15 --max-reads inf --reduce-reads-for-coverage inf
```

## Step2 To remove adapter sequences and low-quality reads, use `Trimmomatic` version （0.39）

```
trimmomatic PE ./JPSH_1.fq.gz  ./JPSH_2.fq.gz  -phred33 out_read1.fq read1_unpaired.fq  out_read2.fq read2_unpaired.fq ILLUMINACLIP:./TruSeq3-PE.fa:2:30:10:8:TRUE  LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36 -threads 20
```

## Step3
Assembled the reads using `Trinity` version (2.15.110) with default parameters using `Singularity` version (3.10.0)

```
singularity exec -e trinityrnaseq.v2.15.1.simg Trinity --seqType fq --left out_read1.fq --right out_read2.fq --output trinity.JPSH.Trinity.fasta --max_memory 100G --CPU 40
```

## Step4_BLASTX
Performing BLASTX alignment using `DIAMOND` version (2.1.6) and set ``` --max-targer-seqs 1 ``` and ``` --evalue 1e-20 ```.
The database is NCBI NR database (last accessed on 22 JUN 2023)

```
diamond blastx --db ./nr.dmnd -q trinity.JPSH.Trinity.fasta -o trinity.nr.JPSH --evalue 1e-20  --threads 96 --outfmt 6 qseqid qlen sseqid pident slen qcovhsp scovhsp evalue bitscore sscinames sskingdoms staxids stitle --max-target-seqs 1
```
Set a threshold to filter for novel viruses:
																							pident <= 80%, scovhsp >=75
```
grep  'Viruses' trinity.nr.JPSH | awk '$4<=80 && $7>=75' | sort -k4nr > trinity.nr.JPSH.filter
```	


	
## Step5 bowite2_metatrans
Reads were mapped back to the viral genomes using `Bowtie2` version (2.2.5 12) and SAMtools version (1.6)
```
bowtie2-build  ./virus_merge.fasta ./index/JPSH_trans
bowtie2 -p 40  -x ./index/JPSH_trans -q -1 JPSH_1.fq.gz -2 JPSH_2.fq.gz -S JPSH.sam
samtools view -bS -h JPSH.sam -o JPSH.bam -@ 20
samtools sort JPSH.bam -o JPSH.sort.bam -@ 20
samtools index JPSH.sort.bam
samtools depth -d 300000 JPSH.sort.bam > JPSH.sort.depth
```
	
## Step6 bowtie_siRNA
`Cutadapt` version (4.4 15) played a role in the removal of adapter sequences and low-quality reads from raw data
The sequence `"GTTCAGAGTTCTACAGTCCGACGATC"` is the 5' end adapter sequence.
```
 cutadapt -a GTTCAGAGTTCTACAGTCCGACGATC JPSH.clean.fa.gz > JPSH.fq.cutadapt.gz
```

Alignment of resulting sequences to the viral genome was performed using `Bowtie` version (1.3.1)
```
bowtie-build  ./virus_merge.fasta ./index/JPSH_siRNA
bowtie -p 40 -n 1 -l 10 -m 100 -k 1 --best --strata  -x ./index/JPSH_siRNA -q JPSH.fq.cutadapt.gz -S JPSH_siRNA.sam
samtools view -bS -h JPSH_siRNA.sam -o JPSH_siRNA.bam -@ 20
samtools sort JPSH_siRNA.bam -o JPSH_siRNA.sort.bam -@ 20
samtools index JPSH_siRNA.sort.bam
samtools depth -d 300000 JPSH_siRNA.sort.bam > JPSH_siRNA.sort.depth
```

## Step7 phylogenetic
The phylogenetic analysis hinged on the amino acid sequences of the predicted RNA-dependent RNA polymerase (RdRP) region and the Coat peotein
  
  Code examples for virus5:
```
mafft --auto virus5_rdrp.fasta > virus5_rdrp.mafft.fasta
trimal -in virus5_rdrp.mafft.fasta -out virus5_rdrp.mafft.trimal.fasta -automated1
iqtree -s virus5_rdrp.mafft.trimal.fasta -T auto -m MFP -b 1000 -redo
```

# Python script usage:
bam_flag.py To obtain the forward and reverse depth for each virus sequence.
```
bam_file=the path of JPSH_siRNA.sort.bam
output_dir=the path of output files
reference_names=The names of potentially novel virus sequences
```
Result file of bam_flag.py:
```
forward_output_file = f"{output_dir}{reference_name}_forward.bam[TRINITY_DN787_c0_g1_i1.txt](https://github.com/Gyoungwe/novel_virus_analyse/files/12568205/TRINITY_DN787_c0_g1_i1.txt)

reverse_output_file = f"{output_dir}{reference_name}_reverse.bam
```
sRNA_analyse.py In order to obtain the distribution of siRNAs from 18nt to 30nt for each virus sequence, as well as the 5' end nucleotide preference.
```
bam_file=the path of JPSH_siRNA.sort.bam
output_dir=the path of output files
reference_names=The names of potentially novel virus sequences
```
Result of sRNA_analyse.py:
Counts of siRNA
```
#the siRNA counts of TRINITY_DN787_c0_g1_i1:
18	95	169 sRNA
19	296	396 sRNA
20	982	893 sRNA
21	9956	8310 sRNA
22	8824	5076 sRNA
23	935	663 sRNA
24	517	239 sRNA
25	284	93 sRNA
26	229	40 sRNA
27	235	53 sRNA
28	210	22 sRNA
29	190	29 sRNA
30	178	10 sRNA
#The first column represents the length of siRNA, the second column represents the counts of forward siRNAs, and the third column represents the counts of reverse siRNAs.
```
5' end base counts of siRNA
```
#The results require manually changing the thymine (T) bases to uracil (U) bases.
A	3242	5096
G	678	7454
C	8203	355
U	10808	3088
```
# R_script usage :
base_counts.R" and "sRNA_peak.R" only require you to set the working directory to the location where the output files of "sRNA_analyse.py" are located, and set "file_names" to the prefix of the files for them to function properly

```setwd("where/the/output/files/of/'sRNA_analyse.py'")```

Example:

```file_names <- c("TRINITY_DN787_c0_g1_i1", "TRINITY_DN5_c0_g1_i1","TRINITY_DN66897_c0_g1_i1","virus5","TRINITY_DN773_c0_g2_i1","TRINITY_DN773_c0_g1_i1")```

gene_structure.R

 Manually input the predicted loci, along with the depth file generated using SAMtools, as inputs

sRNA_depth.R

 Calculate the forward and reverse depth for each sequence using SAMools depth, and use it as an input file
