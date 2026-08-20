# Benchmark workflow — Snakemake launch

This document gives simplified and anonymised examples of the commands used to launch the benchmarking workflows during my Master's project.

The benchmark workflow was created to help compare structural-variant caller outputs with reference datasets using **Truvari**. Benchmarking was necessary to evaluate the callers used in the project, but the development of a benchmarking framework itself was not the main objective of the thesis. I therefore relied extensively on existing documentation and AI-assisted coding to help write, adapt and debug parts of these workflows. All commands, parameters and outputs used for the final analyses were checked before interpretation.

The public version is included mainly for **transparency**, so that readers of the thesis can see how the benchmarking analyses were organised.

> All paths shown below are generic examples. Internal paths, environments and cluster configuration have been removed.

---

## 1. Filtering VCF files before Truvari

Before benchmarking, VCF files can be prepared and filtered through the corresponding Snakemake workflow.

### Dry-run

```bash
snakemake \
  --snakefile /path/to/Snakemake_Workflows/Benchmark/Snakefile_Truvari.smk \
  --cores 20 \
  --jobs 30 \
  --directory /path/to/working_directory \
  --configfile /path/to/Snakemake_Workflows/Benchmark/config_Truvari.yaml \
  --profile /path/to/cluster/profile \
  -p -n "all_filters.done"
```

### Run

```bash
nohup snakemake \
  --snakefile /path/to/Snakemake_Workflows/Benchmark/Snakefile_Truvari.smk \
  --cores 20 \
  --jobs 30 \
  --directory /path/to/working_directory \
  --configfile /path/to/Snakemake_Workflows/Benchmark/config_Truvari.yaml \
  --profile /path/to/cluster/profile \
  -p "all_filters.done" \
  &>> LOG-YYYY-MM-DD-Filter &
```

The log can be followed with:

```bash
tail -f LOG-YYYY-MM-DD-Filter
```

---

## 2. Running Truvari

The benchmark can then be launched on the prepared VCF files.

### Dry-run

```bash
snakemake \
  --snakefile /path/to/Snakemake_Workflows/Benchmark/Snakefile_Truvari.smk \
  --cores 20 \
  --jobs 30 \
  --directory /path/to/working_directory \
  --configfile /path/to/Snakemake_Workflows/Benchmark/config_Truvari.yaml \
  --profile /path/to/cluster/profile \
  -p -n "all_truvari.done"
```

### Run

```bash
nohup snakemake \
  --snakefile /path/to/Snakemake_Workflows/Benchmark/Snakefile_Truvari.smk \
  --cores 20 \
  --jobs 30 \
  --directory /path/to/working_directory \
  --configfile /path/to/Snakemake_Workflows/Benchmark/config_Truvari.yaml \
  --profile /path/to/cluster/profile \
  -p "all_truvari.done" \
  &>> LOG-YYYY-MM-DD-Truvari &
```

---

## 3. Benchmarking split VCF files

For analyses in which VCF files were separated according to SV class or size, a dedicated workflow was used.

### Dry-run

```bash
snakemake \
  --snakefile /path/to/Snakemake_Workflows/Benchmark/Snakefile_Truvari_Split.smk \
  --cores 20 \
  --jobs 30 \
  --directory /path/to/working_directory \
  --configfile /path/to/Snakemake_Workflows/Benchmark/config_Truvari_Split.yaml \
  --profile /path/to/cluster/profile \
  -p -n "all_truvari_split.done"
```

### Run

```bash
nohup snakemake \
  --snakefile /path/to/Snakemake_Workflows/Benchmark/Snakefile_Truvari_Split.smk \
  --cores 20 \
  --jobs 5 \
  --directory /path/to/working_directory \
  --configfile /path/to/Snakemake_Workflows/Benchmark/config_Truvari_Split.yaml \
  --profile /path/to/cluster/profile \
  -p "all_truvari_split.done" \
  &>> LOG-YYYY-MM-DD-Truvari-Split &
```

---

## 4. Counting variants

A separate Snakemake workflow was also used to count variants in the prepared datasets.

### Dry-run

```bash
snakemake \
  --snakefile /path/to/Snakemake_Workflows/Benchmark/Snakefile_CountVariants.smk \
  --cores 20 \
  --jobs 30 \
  --directory /path/to/working_directory \
  --configfile /path/to/Snakemake_Workflows/Benchmark/config_Truvari_Split.yaml \
  --profile /path/to/cluster/profile \
  -n
```

### Run

```bash
nohup snakemake \
  --snakefile /path/to/Snakemake_Workflows/Benchmark/Snakefile_CountVariants.smk \
  --cores 20 \
  --jobs 30 \
  --directory /path/to/working_directory \
  --configfile /path/to/Snakemake_Workflows/Benchmark/config_Truvari_Split.yaml \
  --profile /path/to/cluster/profile \
  &>> LOG-YYYY-MM-DD-CountVariants &
```

---

## Useful options

To continue a workflow after an interrupted or incomplete run, Snakemake can be launched with:

```bash
--rerun-incomplete
```

A rule graph can also be generated to inspect the workflow structure:

```bash
mydate=$(date +%Y%m%d)

snakemake \
  --snakefile /path/to/Snakemake_Workflows/Benchmark/Snakefile_Truvari.smk \
  --configfile /path/to/Snakemake_Workflows/Benchmark/config_Truvari.yaml \
  --rulegraph --forceall \
  | dot -Tpdf > "flow-Benchmark-${mydate}.pdf"
```

---

## Note

These examples document how benchmarking was organised during the project. Resource values such as `--cores` and `--jobs`, as well as cluster profiles and file paths, must be adapted to the computing environment.

The workflow is provided as supporting material for the Master's thesis and should be read together with the benchmarking methodology described in the report.
