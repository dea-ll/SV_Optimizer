# Launching the Dysgu Snakemake workflow

## Optional environment creation

```bash
bsub -q normal -L /bin/bash -J InstDysguFix -u user@example.org -N \
  "source /path/to/Conda/Miniconda/etc/profile.d/conda.sh;
   mamba create -y -n dysgu_env --channel-priority flexible -c conda-forge dysgu"
```

## Dry-run

```bash
mydate=$(date +%Y%m%d)

snakemake \
  --snakefile /path/to/project/workflows/Dysgu/Snakefile_Dysgu.smk \
  --cores 20 \
  --jobs 2 \
  --directory $(pwd) \
  --configfile /path/to/project/workflows/Dysgu/config_Dysgu.yaml \
  --profile /path/to/lsf/profile \
  -p -n "all_dysgu.done"
```

## Run

```bash
nohup snakemake \
  --snakefile /path/to/project/workflows/Dysgu/Snakefile_Dysgu.smk \
  --cores 20 \
  --jobs 2 \
  --directory $(pwd) \
  --configfile /path/to/project/workflows/Dysgu/config_Dysgu.yaml \
  --profile /path/to/lsf/profile \
  -p "all_dysgu.done" \
  &>> LOG-YYYY-MM-DD &
```

To continue after an interrupted run:

```bash
--rerun-incomplete
```
