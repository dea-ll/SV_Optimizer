# Launching the Delly Snakemake workflow

## Dry-run

```bash
mydate=$(date +%Y%m%d)

snakemake \
  --snakefile /path/to/project/workflows/Delly/Snakefile_Delly.smk \
  --cores 20 \
  --jobs 3 \
  --directory $(pwd) \
  --configfile /path/to/project/workflows/Delly/config_Delly.yaml \
  --profile /path/to/lsf/profile \
  -p -n "all_delly.done"
```

## Run

```bash
nohup snakemake \
  --snakefile /path/to/project/workflows/Delly/Snakefile_Delly.smk \
  --cores 20 \
  --jobs 2 \
  --directory $(pwd) \
  --configfile /path/to/project/workflows/Delly/config_Delly.yaml \
  --profile /path/to/lsf/profile \
  -p "all_delly.done" \
  &>> LOG-YYYY-MM-DD &
```

To continue after an interrupted run:

```bash
--rerun-incomplete
```
