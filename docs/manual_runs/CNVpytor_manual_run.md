# CNVpytor — manual run notes

This document preserves the supplied development command sequence while replacing sensitive paths, identifiers, genomic loci and email addresses.

## Installation

```bash
bsub -q normal -L /bin/bash \
  -J CNVpytor_env_min \
  -u user@example.org -N \
  -M 8000 \
  -o CNVpytor_env_min.log \
  "source /path/to/Conda/Miniconda/etc/profile.d/conda.sh; \
   conda create \
     -p /path/to/environnements/cnvpytor_env \
     -c conda-forge \
     python=3.10 numpy scipy matplotlib h5py pysam requests xlsxwriter \
     -y"
```

## Step 1 — Create `.pytor` files

```bash
bsub -q normal -L /bin/bash \
  -J CNVpytor_step1_rd \
  -u user@example.org -N \
  -M 8000 -n 4 \
  -o CNVpytor_step1_rd.log \
  "source /path/to/Conda/Miniconda/etc/profile.d/conda.sh; \
   conda activate /path/to/environnements/cnvpytor_env; \
   mkdir -p CNVpytor; \
   for bam in *.genome.bam; do \
     sample=\${bam%.genome.bam}; \
     cnvpytor \
       -root CNVpytor/\${sample}.pytor \
       -rd \${bam} \
       -T /path/to/Genome/genome_PAR_masked.fasta; \
   done"
```

## Step 2 — Create histograms

The workflow used a 1,500-bp bin size.

```bash
bsub -q normal -L /bin/bash \
  -J CNVpytor_step2_his \
  -u user@example.org -N \
  -M 8000 -n 4 \
  -o CNVpytor_step2_his.log \
  "source /path/to/Conda/Miniconda/etc/profile.d/conda.sh; \
   conda activate /path/to/environnements/cnvpytor_env; \
   for pytor in CNVpytor/*.pytor; do \
     echo Processing HIS on \${pytor}; \
     cnvpytor -root \${pytor} -his 1500; \
   done"
```

## Step 3 — Partition

```bash
bsub -q normal -L /bin/bash \
  -J CNVpytor_step3_partition \
  -u user@example.org -N \
  -n 4 \
  -o CNVpytor_step3_partition.log \
  "source /path/to/Conda/Miniconda/etc/profile.d/conda.sh; \
   conda activate /path/to/environnements/cnvpytor_env; \
   for pytor in CNVpytor/*.pytor; do \
     cnvpytor -root \${pytor} -partition 1500; \
   done"
```

## Step 4 — Call CNVs

```bash
bsub -q normal -L /bin/bash \
  -J CNVpytor_step4_call \
  -u user@example.org -N \
  -n 4 \
  -o CNVpytor_step4_call.log \
  "source /path/to/Conda/Miniconda/etc/profile.d/conda.sh; \
   conda activate /path/to/environnements/cnvpytor_env; \
   mkdir -p CNVpytor_calls; \
   for pytor in CNVpytor/*.pytor; do \
     sample=\$(basename \${pytor} .pytor); \
     cnvpytor -root \${pytor} -call 1500 \
       > CNVpytor_calls/\${sample}.CNVpytor_1500.txt; \
   done"
```

## Step 5 — Generate VCF files

```bash
bsub -q normal -L /bin/bash \
  -J CNVpytor_vcf_batch_1500 \
  -u user@example.org -N \
  -n 4 \
  -o CNVpytor_vcf_batch_1500.log \
  "source /path/to/Conda/Miniconda/etc/profile.d/conda.sh; \
   conda activate /path/to/environnements/cnvpytor_env; \
   mkdir -p CNVpytor_vcf; \
   for pytor in CNVpytor/*.pytor; do \
     sample=\$(basename \${pytor} .pytor); \
     echo -e \"set print_filename CNVpytor_vcf/\${sample}_1500.vcf\nprint calls\n\" \
       | cnvpytor -root \${pytor} -view 1500; \
   done"
```

## Merged-call table

```bash
bsub -q normal -L /bin/bash \
  -J CNVpytor_merged_calls_1500 \
  -u user@example.org -N \
  -n 4 \
  -o CNVpytor_merged_calls_1500.log \
  "source /path/to/Conda/Miniconda/etc/profile.d/conda.sh; \
   conda activate /path/to/environnements/cnvpytor_env; \
   pytor_files=\"\"; \
   for f in CNVpytor/*.pytor; do \
     pytor_files=\"\$pytor_files \$f\"; \
   done; \
   echo -e 'set Q0_range 0 0.5\nset size_range 100000 inf\nset print_filename CNVpytor_merged_calls_1500.tsv\nprint merged_calls\n' \
     | cnvpytor -root \$pytor_files -view 1500"
```

## Frequency table

```bash
bsub -q normal -L /bin/bash \
  -J CNVpytor_Table \
  -u user@example.org -N \
  "python cnvpytor_freq_from_merged.py \
   CNVpytor_merged_calls_1500.tsv \
   CNVpytor_merged_calls_1500.freq.tsv"
```

## Example plot commands

### Manhattan plot

```bash
bsub -q normal -L /bin/bash \
  -J CNVpytor_plots \
  -u user@example.org -N \
  -n 4 \
  -o CNVpytor_plots.log \
  "source /path/to/Conda/Miniconda/etc/profile.d/conda.sh; \
   conda activate /path/to/environnements/cnvpytor_env; \
   mkdir -p /path/to/output/CNVpytor_Graphs; \
   cd /path/to/project/VCFs/CNVpytor; \
   while read sample; do \
     echo Processing \$sample; \
     cnvpytor \
       -root \${sample}.pytor \
       -plot manhattan 1500 \
       -o /path/to/output/CNVpytor_Graphs/\${sample}.manhattan.1500.png; \
   done < sample_list.txt"
```

### Region plot

```bash
bsub -q normal -L /bin/bash \
  -J CNVpytor_region_plot \
  -u user@example.org -N \
  -n 4 \
  -o CNVpytor_region_plot.log \
  "source /path/to/Conda/Miniconda/etc/profile.d/conda.sh; \
   conda activate /path/to/environnements/cnvpytor_env; \
   cnvpytor \
     -root /path/to/project/VCFs/CNVpytor/SAMPLE_ID.pytor \
     -plot regions \"CHR:START-END\" 1500 \
     -panels rd \
     -o /path/to/output/SAMPLE_ID.region.1500.rd.png"
```
