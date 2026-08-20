# Delly — manual run notes

This document preserves the supplied development command sequence while replacing sensitive paths and identifiers.

## Program and reference paths

```bash
ProgDir="/path/to/Progs"
Exclusions="$ProgDir/DELLY/delly/excludeTemplates/human.hg19.excl.noChr.tsv"
Genome="/path/to/Genome/hg19/genome_PAR_masked.fasta"
```

## Create BAM symlinks

```bash
mkdir -p Delly

for file in /path/to/Bams/*.bam; do
  ln -s "$file" Delly/
  ln -s "$file.bai" Delly/
done
```

## Run Delly

```bash
mydate=$(date +%Y%m%d)

cd Delly

a=0
for file in $(ls *.bam); do
  echo $file
  a=$((a + 1))
  RootName=$(echo $file | cut -d'_' -f1,2,3)
  echo $RootName

  bsub -q normal -L /bin/bash \
    -J delly$a \
    -e LOG-delly-$RootName \
    -o LOG-delly-$RootName \
    -u user@example.org \
    -N \
    "export PATH=/path/to/Progs/DELLY/delly/src/htslib:\$PATH;
     export LD_LIBRARY_PATH=/path/to/Progs/DELLY/htslib/lib:\$LD_LIBRARY_PATH;
     delly call \
       -o $RootName'.Delly.raw.'$mydate'.bcf' \
       -x $Exclusions \
       -q 20 \
       -g $Genome \
       $file;"

  sleep 5s

  nbcpt=$(bjobs | grep "delly" | wc -l)
  while [ \$nbcpt -gt 1 ]; do
    sleep 5m
    nbcpt=$(bjobs | grep "delly" | wc -l)
  done
done

cd ..
```

## Filtering command present in the supplied development document

The supplied manual document contains an **inversion-specific** filtering example:

- average mapping quality >30
- paired-end support >5
- `FILTER=PASS`
- inversion ALT

```bash
cd Delly

a=0
for file in $(ls *.Delly.raw.*.bcf); do
  echo $file
  a=$((a + 1))

  mydate=$(echo $file | cut -d'.' -f4)
  SampleName=$(echo $file | cut -d'.' -f1)
  Output="${SampleName}.genome.delly.inv.filtered.${mydate}.vcf"

  bsub -q normal -L /bin/bash -J dellyf$a -u user@example.org -N \
    "PATH=\$ProgDir/bcftools/1.15.1/bin/:\$PATH;
     bcftools filter \
       -i 'MAPQ>30 && PE>5 && FILTER=\"PASS\" && ALT~\"INV\"' \
       -O v \
       -o \$Output \
       \$file;"
done

cd ..
```

> Important: the final thesis panel uses Delly for deletions >10 kb and duplications >50 bp. The validated DEL/DUP-specific filtering logic should be copied from the actual Snakemake workflow source. It is not present in the supplied manual-run document and is therefore not reconstructed here.
