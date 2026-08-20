# Manta — manual run notes

This document preserves the command sequence used during development, with sensitive paths, sample identifiers and email addresses replaced by generic placeholders.

## Copy BAM files

```bash
bsub -q normal -L /bin/bash -J Copy -u user@example.org -N \
  "cp /path/to/Datasets/01_Bam_files_for_testing/*bam ."

bsub -q normal -L /bin/bash -J Copy -u user@example.org -N \
  "cp /path/to/Datasets/01_Bam_files_for_testing/SAMPLE_ID.genome.bam.bai ."
```

## Program directory

```bash
ProgDir=/path/to/Progs
```

## Index BAM files

```bash
a=0
for file in $(ls *.bam); do
  echo $file
  a=$((a + 1))
  bsub -q normal -L /bin/bash -J SamInd$a -u user@example.org -N \
    "export PATH=\$ProgDir/samtools/:\$PATH ; samtools index \$file;"
done
```

## Step 1 — Manta configuration

```bash
ProgDir=/path/to/Progs
mkdir -p Manta
Genome=/path/to/Genome/hg19/genome_PAR_masked.fasta

a=0
for file in $(ls *.bam); do
  echo $file
  a=$((a + 1))
  RunDir='RunDir_'$(echo \$file | cut -d'_' -f1,2,3 | sed 's/\.bam//')
  cd Manta
  export PATH=\$ProgDir/Manta/manta-1.6.0.centos6_x86_64/bin/:\$PATH
  configManta.py \
    --bam ../\$file \
    --referenceFasta \$Genome \
    --runDir \$RunDir \
    --generateEvidenceBam \
    --outputContig \
    --callRegions=\$ProgDir/Manta/hg19.main-chromosomes.bed.gz
  cd ../
done
```

## Step 2 — Execute Manta

```bash
cd Manta
a=0
for folder in $(ls -d RunDir*/); do
  echo \$folder
  a=$((a + 1))
  cd \$folder

  bsub -q normal -L /bin/bash \
    -J manta$a \
    -n 8 \
    -R "span[ptile=8]" \
    -u user@example.org \
    -N \
    -e LOG-$a \
    "./runWorkflow.py -m local -j 8"

  cd ../
  sleep 5s

  nbcpt=$(bjobs | grep "manta" | wc -l)
  while [ \$nbcpt -gt 2 ]; do
    sleep 5m
    nbcpt=$(bjobs | grep "manta" | wc -l)
  done
done
cd ../
```

## Step 3 — Extract VCF

```bash
ProgDir=/path/to/Progs
mydate=$(date +%Y%m%d)

cd Manta
a=0
for folder in $(ls -d RunDir*/); do
  echo \$folder
  a=$((a + 1))
  foldername=$(echo \$folder | sed 's/.$//' | sed 's/RunDir_//')
  cd \$folder/results/variants/

  bsub -q normal -L /bin/bash -J unzip$a -u user@example.org -N -e LOG-$a \
    "gunzip -c diploidSV.vcf.gz > \$foldername'.manta.diploidSV.'\$mydate'.vcf'"

  cd ../../../
done
cd ..
```

## Step 4 — Convert inversions

```bash
ProgDir=/path/to/Progs
chmod +x \$ProgDir/Manta/manta-1.6.0.centos6_x86_64/libexec/convertInversion.py
Genome=/path/to/Genome/hg19/genome_PAR_masked.fasta

cd Manta
export PATH=\$ProgDir/samtools/:\$PATH

a=0
for folder in $(ls -d RunDir*/); do
  echo \$folder
  a=$((a + 1))
  foldername=$(echo \$folder | sed 's/.$//' | sed 's/RunDir_//')
  cd \$folder/results/variants/

  VCFfile=$(ls *.manta.diploidSV*vcf | grep -v diploidSVinv)
  VCFinvFile=$(echo \$VCFfile | sed 's/diploidSV/diploidSVinv/')

  bsub -q normal -L /bin/bash -J manta-inv$a -u user@example.org -N -e LOG-$a \
    "\$ProgDir/Manta/manta-1.6.0.centos6_x86_64/libexec/convertInversion.py \
     \$ProgDir/samtools/samtools \$Genome \$VCFfile > \$VCFinvFile;
     cp \$VCFinvFile ../../../;"

  cd ../../../
done
cd ..
```

## Step 5 — Filter deletions <10 kb

Original analytical criteria:

- `FILTER=PASS`
- genotype quality >0
- `SVTYPE=DEL`
- deletion size <10 kb

```bash
ProgDir=/path/to/Progs
cd Manta

a=0
for file in $(ls *.manta.diploidSVinv.*.vcf); do
  echo \$file
  a=$((a + 1))
  mydate=$(echo \$file | cut -d'.' -f5)
  SampleName=$(echo \$file | cut -d'.' -f1)

  bsub -q normal -L /bin/bash -J manta-f$a -u user@example.org -N -e LOG-$a \
    "export PATH=\$ProgDir/bcftools/1.15.1/bin/:\$PATH;
     bcftools filter \
       -i 'FILTER==\"PASS\" && (GQ>0) && SVTYPE==\"DEL\" && SVLEN<0 && SVLEN>-10000' \
       -O v \
       -o \$SampleName'.genome.manta.del_max10kb.filtered.'\$mydate'.vcf' \
       \$file"
done

cd ..
```

## Step 6 — Convert VCF to BED

```bash
cd Manta
a=0

for file in $(ls *manta.del_max10kb*.vcf); do
  echo \$file
  a=$((a + 1))
  filename=$(echo \$file | sed 's/\.vcf$/\.bed/')

  bsub -q normal -L /bin/bash -J cnvt2bed$a -u user@example.org -N -e LOG-LSF \
    "export PATH=\$ProgDir/BEDOPS/bin-v2.4.40/:\$PATH;
     convert2bed --input=vcf --deletions < \$file > \$filename"
done

cd ..
```
