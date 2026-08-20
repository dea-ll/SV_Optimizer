# Launching the Manta Snakemake workflow

## Dry-run

```bash
mydate=$(date +%Y%m%d)

snakemake \
  --snakefile /path/to/project/workflows/Manta/Snakefile_Manta.smk \
  --cores 30 \
  --jobs 3 \
  --directory $(pwd) \
  --configfile /path/to/project/workflows/Manta/config_Manta.yaml \
  --profile /path/to/lsf/profile \
  -p -n "all_manta.done"
```

Optional DAG:

```bash
snakemake \
  --snakefile /path/to/project/workflows/Manta/Snakefile_Manta.smk \
  --configfile /path/to/project/workflows/Manta/config_Manta.yaml \
  --rulegraph --forceall \
  | grep -A 5000 snakemake_dag \
  | dot -Tpdf > "flow-Manta-${mydate}.pdf"
```

## Run

```bash
nohup snakemake \
  --snakefile /path/to/project/workflows/Manta/Snakefile_Manta.smk \
  --cores 30 \
  --jobs 2 \
  --directory $(pwd) \
  --configfile /path/to/project/workflows/Manta/config_Manta.yaml \
  --profile /path/to/lsf/profile \
  -p "all_manta.done" \
  &>> LOG-YYYY-MM-DD &
```

To continue after an interrupted run:

```bash
--rerun-incomplete
```
