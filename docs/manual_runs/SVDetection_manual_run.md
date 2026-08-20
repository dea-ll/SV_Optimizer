# SVDetection — manual development notes

This file summarises the main downstream steps that were progressively brought together in the SVDetection Snakemake workflow during the Master's project.

The original analysis relied on several commands and internal scripts from the HUG structural-variant workflow **Spica Virginis**. The examples below are intentionally simplified and anonymised. Internal scripts, patient data, sample lists, databases and laboratory paths are not included.

## 1. Data formatting

Caller-specific VCF files were first processed by DataFormater scripts.

Conceptually, the command had the following structure:

```bash
python3 /path/to/internal/DataFormater_CALLER.py \
  --parameter_file=/path/to/internal/parameters_CALLER.txt
```

The DataFormater step prepares caller-specific SV output for the downstream aggregation framework. Depending on the caller, it extracts information such as:

- chromosome and genomic coordinates;
- SV type;
- SV size;
- genotype or caller-specific information;
- source caller and detection strategy.

Different DataFormater scripts or parameter files can be used for different callers and SV classes.

## 2. Aggregation

After formatting, related SV calls are aggregated using the internal HUG framework.

A simplified representation of the original command is:

```bash
perl /path/to/internal/Create_SVF_database.pl \
  --parameter_file=/path/to/internal/parameters_CALLER.txt \
  --data_json_file=/path/to/formatted/caller.data.json
```

Aggregation groups related structural variants into SV families and allows recurrence to be assessed across the list of samples included in the analysis.

This produces information such as the internal SV frequency (`SVF`), which can subsequently be used during prioritisation.

The internal aggregation implementation is not included in the public repository.

## 3. AnnotSV annotation

Aggregated BED files are then annotated with AnnotSV.

A simplified command is:

```bash
AnnotSV \
  -SVinputFile /path/to/aggregated/SAMPLE_ID.caller.aggregated.bed \
  -svtBEDcol 4 \
  -genomeBuild GRCh37 \
  -annotationMode both \
  -outputFile /path/to/output/SAMPLE_ID.caller.annotated.tsv \
  -outputDir /path/to/output/
```

AnnotSV adds genomic and population information used in subsequent review and prioritisation.

## 4. Filtration

Annotated output is then processed by the internal SV filtration framework.

A simplified representation is:

```bash
python3 /path/to/internal/sv_filter/runner.py \
  -i /path/to/annotation/*.tsv \
  -p <PANEL_INFORMATION> \
  -g <GENE_INFORMATION>
```

The filtration step reduces the initial callset and generates candidate variants for further review.

## From manual commands to Snakemake

During the project, these successive commands were reorganised into a Snakemake workflow with separate rules for:

```text
DataFormater
    ↓
Aggregation
    ↓
AnnotSV
    ↓
Filtration
```

This made it possible to launch the complete sequence through a single workflow while preserving the existing HUG analysis logic and extending it to the callers retained during the project.

## Confidentiality

The examples in this file intentionally omit:

- patient/sample identifiers;
- internal HUG paths and server names;
- internal Perl and Python source code;
- laboratory databases;
- clinical information;
- non-public parameter files.

The purpose of this document is to explain the workflow logic, not to reproduce the complete internal Spica Virginis implementation.
