# Launching the downstream SVDetection workflow

The downstream workflow is organised into:

1. Data formatting
2. Aggregation
3. Annotation
4. Filtration

## Dry-run

```bash
mydate=$(date +%Y%m%d)

snakemake \
  --snakefile /path/to/project/SVDetection/Snakefile_SVdetection.smk \
  --cores 20 \
  --jobs 10 \
  --directory $(pwd) \
  --configfile /path/to/project/SVDetection/config_SVdetection.yaml \
  --profile /path/to/lsf/profile \
  -p -n "all_filtration.done"
```

Possible stage targets include:

```text
all_dataformater.done
all_aggregation.done
all_annotation.done
all_filtration.done
```

## Run

```bash
nohup snakemake \
  --snakefile /path/to/project/SVDetection/Snakefile_SVdetection.smk \
  --cores 20 \
  --jobs 8 \
  --directory $(pwd) \
  --configfile /path/to/project/SVDetection/config_SVdetection.yaml \
  --profile /path/to/lsf/profile \
  -p "all_filtration.done" \
  &>> LOG-YYYY-MM-DD &
```

To continue after an interrupted run:

```bash
--rerun-incomplete
```
