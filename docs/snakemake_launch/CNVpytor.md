# Launching the CNVpytor Snakemake workflow

## Dry-run

```bash
mydate=$(date +%Y%m%d)

snakemake \
  --snakefile /path/to/project/workflows/CNVpytor/Snakefile_CNVpytor.smk \
  --cores 20 \
  --jobs 3 \
  --directory $(pwd) \
  --configfile /path/to/project/workflows/CNVpytor/config_CNVpytor.yaml \
  --profile /path/to/lsf/profile \
  -p -n "all_cnvpytor.done"
```

Useful Snakemake command when required:

```bash
snakemake --unlock
```

## Run

```bash
nohup snakemake \
  --snakefile /path/to/project/workflows/CNVpytor/Snakefile_CNVpytor.smk \
  --cores 20 \
  --jobs 2 \
  --directory $(pwd) \
  --configfile /path/to/project/workflows/CNVpytor/config_CNVpytor.yaml \
  --use-singularity \
  --profile /path/to/lsf/profile \
  -p "all_cnvpytor.done" \
  &>> LOG-YYYY-MM-DD &
```

If local bind mounts are required:

```bash
--singularity-args "--bind $PWD,/path/to/reference,/path/to/cnvpytor/scripts"
```

To continue after an interrupted run:

```bash
--rerun-incomplete
```
