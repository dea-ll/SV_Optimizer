# Dysgu — manual run notes

This document preserves the development command sequence while replacing sensitive paths and identifiers.

## Installation

Mamba was used because dependency resolution was problematic with Conda alone.

```bash
bsub -q normal -L /bin/bash -J InstDysguFix -u user@example.org -N \
  "source /path/to/Conda/Miniconda/etc/profile.d/conda.sh;
   mamba create -y -n dysgu_env --channel-priority flexible -c conda-forge dysgu"
```

## Setup

```bash
ref="/path/to/Genome/genome_PAR_masked.fasta"
cores=4
outdir="dysgu_res"
mkdir -p $outdir
```

## Step 1 — Run Dysgu

```bash
for path in *.bam; do
  sample=$(basename "$path" .bam)

  bsub -q normal -L /bin/bash \
    -n $cores \
    -J dysgu_$sample \
    -e $outdir/${sample}.log \
    -u user@example.org \
    -N \
    "source /path/to/Conda/Miniconda/etc/profile.d/conda.sh;
     conda activate /path/to/environnements/dysgu_env;
     dysgu run -p $cores \
       -v2 \
       $ref \
       $outdir/${sample}_tmp \
       $path \
       > $outdir/${sample}.vcf 2>> $outdir/${sample}.log"
done
```

## Step 2 — Filter deletions

The supplied development document contains the deletion filter below.

```bash
a=0
for vcf in $outdir/*.vcf; do
  sample=$(basename "$vcf" .vcf)
  a=$((a + 1))

  bsub -q normal -L /bin/bash \
    -J filter_$sample \
    -e $outdir/${sample}.filter.log \
    -u user@example.org \
    -N \
    "export PATH=/path/to/Progs/bcftools/1.15.1/bin:\$PATH;
     bcftools view \
       -i 'SVTYPE==\"DEL\" && (GQ>0)' \
       $vcf \
       -Ov \
       -o $outdir/${sample}.filtered_DEL.vcf"
done
```

## Step 3 — Convert filtered VCF to BED

```bash
a=0

for file in dysgu_res/*filtered_DEL.vcf; do
  echo $file
  a=$((a + 1))
  filename=$(echo "$file" | sed 's/\.vcf$/.bed/')

  bsub -q normal -L /bin/bash \
    -J cnvt2bed$a \
    -u user@example.org \
    -N \
    -e LOG-LSF \
    "export PATH=/path/to/Progs/bcftools/1.15.1/bin:\$PATH;
     bcftools query -f '%CHROM\t%POS\t%INFO/END\n' $file > $filename"
done
```

> Important: the final thesis panel also uses Dysgu for large deletions and duplications. Their validated filters should be copied from the actual Snakemake workflow source before publication; they are not present in the supplied manual-run document and are therefore not invented here.
