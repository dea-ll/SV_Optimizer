# Short-read WGS structural variant analysis workflows 🧬

This repository contains the Snakemake workflows developed and adapted during my Master's thesis in **Bioinformatics and Data Analysis in Biology at the University of Geneva**, carried out in the context of diagnostic genomics at Geneva University Hospitals (HUG).

My project focused on **structural variant (SV) analysis from short-read whole-genome sequencing (WGS)**, with a particular interest in deletions and duplications.

Structural variant detection remains challenging because different callers rely on different sequencing signals and their performance varies according to SV type, size and genomic context. During this project, I evaluated several SV detection approaches, compared their performance on public and internal validation data, and selected a reduced panel of complementary callers.

A second major objective was to make the analysis more reproducible and easier to execute. Procedures that were initially performed through individual commands and scripts were progressively reorganised into **modular Snakemake workflows**, covering both SV calling and the subsequent processing of the resulting variants.

This repository accompanies my Master's thesis and provides a transparent overview of the computational work performed during the project.

> **Confidentiality notice**
>
> This repository contains only material that can be shared publicly. No patient-derived sequencing data, clinical information, sample identifiers, internal server addresses, credentials or other sensitive information are included. Laboratory-specific paths are replaced by generic placeholders such as `/path/to/...`.
>
> Some components of the downstream SV analysis rely on internal HUG scripts and resources and are therefore documented here but not distributed.

---

## Project objectives 

The project addressed two closely related questions:

1. **Which SV callers provide useful and complementary detection performance for the SV classes investigated in the laboratory?**
2. **How can these tools and the subsequent analysis steps be organised into a reproducible workflow suitable for repeated WGS analyses?**

The aim was not simply to maximise the number of callers included in the analysis. Benchmark performance, complementarity between sequencing signals, computational behaviour and compatibility with downstream processing were all considered when defining the final strategy.

---

## Final caller panel 🎯

The final caller combinations retained during the project were:

| SV category | Retained callers | Main detection strategy |
|---|---|---|
| Deletions, 50 bp–10 kb | **Manta, Dysgu** | Paired-end / split-read |
| Deletions, >10 kb | **Delly, Dysgu, CNVpytor** | Breakpoint evidence + read depth |
| Duplications, >50 bp | **Delly, Dysgu, CNVpytor** | Breakpoint evidence + read depth |

These combinations were selected after benchmarking and validation and reflect the complementary behaviour of the retained tools.

Importantly, the final panel was not determined from a single benchmark metric. Some callers performed well for specific datasets or SV categories but were not retained after considering their behaviour on more representative validation data, redundancy with other tools, computational requirements and integration into the complete workflow.

---

## Repository organisation

The repository contains the Snakemake workflows used for the final SV analysis, an additional workflow used for benchmarking, supporting documentation, and a small collection of anonymised analysis scripts.

```text
.
├── README.md
│
├── Snakemake_Workflows/
│   ├── Manta/
│   ├── Dysgu/
│   ├── Delly/
│   ├── CNVpytor/
│   ├── SVDetection/
│   └── Benchmark/
│
├── envs/
│   ├── Env_Stage.yml
│   ├── cnvpytor_env.yml
│   └── dysgu_env.yml
│
├── docs/
│   ├── manual_runs/
│   │   ├── Manta_manual_run.md
│   │   ├── Dysgu_manual_run.md
│   │   ├── Delly_manual_run.md
│   │   ├── CNVpytor_manual_run.md
│   │   └── SVDetection_manual_run.md
│   │
│   └── snakemake_launch/
│       ├── Manta.md
│       ├── Dysgu.md
│       ├── Delly.md
│       ├── CNVpytor.md
│       ├── SVDetection.md
│       └── Benchmark.md
│
└── Scripts/
    └── example analysis and figure-generation scripts
```

The `manual_runs/` files preserve the main command-line steps used during development in an anonymised form, while `snakemake_launch/` provides simple examples showing how the corresponding workflows were launched.

The `envs/` folder contains exported Conda environment definitions for the main software environments used during the project. These files are included to improve reproducibility without distributing the environments themselves.

The `Scripts/` folder contains selected anonymised scripts used to generate figures or descriptive summaries for the thesis report and oral presentation. These scripts are included to document how some of the results were produced and do not contain patient-level data.

---

## SV caller workflows ⚙️

Four workflows correspond to the callers retained in the final panel:

- **Manta**
- **Dysgu**
- **Delly**
- **CNVpytor**

Each caller workflow follows the same general organisation:

```text
Snakemake_Workflows/Caller/
├── Snakefile_Caller.smk
├── config_Caller.yaml
├── parameters_Caller.py
└── rules/
    └── Caller.rules
```

The files have complementary roles:

- `Snakefile_*.smk` defines and connects the workflow steps;
- `config_*.yaml` contains run-specific information such as input and output locations;
- `parameters_*.py` contains parameters and software or reference paths;
- `rules/*.rules` contains the individual processing steps executed by Snakemake.

This organisation helped me keep the workflows readable and made it easier to modify or rerun individual components during the project.

---

## SVDetection workflow

SV analysis at HUG is performed within an internal workflow called **Spica Virginis**, which combines several callers and downstream processing steps for structural-variant analysis.

During my Master's project, I worked on parts of this existing framework: I reviewed and adapted scripts, extended the processing to the callers retained after benchmarking, and brought the successive downstream commands together into a dedicated Snakemake workflow.

The complete internal implementation of Spica Virginis is **not included in this public repository**. Some Perl and Python scripts, parameter files, databases and laboratory resources are internal and cannot be shared publicly. The public `SVDetection` workflow therefore documents the organisation of the analysis and the interfaces between its main steps without exposing these internal components.

The workflow starts from the VCF files produced by the selected callers and follows four main stages:

```text
Caller VCFs
    │
    ▼
Data formatting
    │
    ▼
Aggregation across samples
    │
    ▼
AnnotSV annotation
    │
    ▼
Filtration
    │
    ▼
Candidate SVs for review
```

### 1. Data formatting

Caller-specific VCF files are converted into a structure that can be processed consistently by the downstream workflow. The DataFormater step extracts the information required for each SV, including genomic coordinates, SV type, size and caller-specific fields, while preserving the source of each prediction.

### 2. Aggregation and internal frequency

Formatted SVs are compared across the list of samples provided for the analysis. Related calls can be grouped into **SV families**, allowing similar events observed in different samples to be identified and an **internal SV frequency (SVF)** to be calculated.

This information is useful for prioritisation, particularly in a rare-disease context, because recurrent events may correspond to common structural variation or to genomic regions repeatedly detected by short-read callers. Internal recurrence is used as contextual information and is not, by itself, considered evidence that an SV is benign or pathogenic.

### 3. Annotation

Aggregated SVs are annotated with **AnnotSV**, adding gene-level, genomic and available population information that can subsequently contribute to variant prioritisation.

### 4. Filtration

The annotated results are filtered to reduce the initial number of predictions and obtain a more manageable set of candidate SVs for review.

The purpose of these steps is to support prioritisation. Clinical interpretation and pathogenicity assessment require additional biological and clinical information and are not performed automatically by the workflow.

---

## Benchmark workflow 📊

A separate **Benchmark** workflow is included to document the analyses used to evaluate caller performance during the project.

It was used to organise the preparation of caller VCF files and the **Truvari-based benchmarking analyses**, including VCF filtering and separation according to the SV categories evaluated in the thesis, benchmark execution, and summary of variant counts.

Benchmarking was necessary to compare the callers and define the final panel, but developing a benchmarking framework was not the central objective of my Master's project. I therefore relied on existing documentation and also used **AI-assisted coding** to help write, adapt and debug parts of these scripts. I decided to include this workflow for transparency and to show how the benchmark results presented in the thesis were generated. The commands, parameters and outputs used for the final analyses were checked before interpretation.

As for the other workflows, only anonymised and shareable material is included. Internal paths, cluster configuration and non-public resources have been removed.

---

## Example scripts 📈

The `Scripts/` folder contains a small selection of scripts used during the project, mainly to generate figures and descriptive summaries for the thesis report or oral presentation.

The versions provided here were adapted for public sharing: patient and sample identifiers were removed, internal paths were replaced by generic placeholders, and only non-sensitive example or summary information is retained.

These scripts are included as supporting material and are intended to make the analyses presented in the thesis easier to follow.

---

## Conda environments

To improve reproducibility, the repository includes the Conda environment definitions used for the main analysis steps:

```text
envs/
├── Env_Stage.yml
├── cnvpytor_env.yml
└── dysgu_env.yml
```

- `Env_Stage.yml` corresponds to the main project environment used for several workflow and analysis steps.
- `cnvpytor_env.yml` contains the environment used for CNVpytor.
- `dysgu_env.yml` contains the environment used for Dysgu.

The files were exported from the environments used during the project with Conda using `--no-builds`. Machine-specific `prefix:` entries were removed before inclusion in the public repository.

An environment can be recreated, for example, with:

```bash
conda env create -f envs/dysgu_env.yml
```

The exact software environment required by a workflow should be checked against its configuration and parameter files. Some internal HUG dependencies used by the downstream `SVDetection` workflow are not distributed in this repository.

---

## Running the workflows

A typical Snakemake dry-run follows this structure:

```bash
snakemake \
  --snakefile /path/to/Snakemake_Workflows/TOOL/Snakefile_TOOL.smk \
  --cores 20 \
  --jobs 3 \
  --directory /path/to/working_directory \
  --configfile /path/to/Snakemake_Workflows/TOOL/config_TOOL.yaml \
  --profile /path/to/cluster/profile \
  -p -n
```

After checking that the expected rules and outputs are correct, the workflow can be launched without `-n`.

More specific examples for each workflow are available in:

```text
docs/snakemake_launch/
```

Resource allocation, paths and cluster profiles must be adapted to the local computing environment. The Conda environment definitions provided in `envs/` can be used to recreate the main software environments associated with the workflows.

---

## Data and confidentiality 🔒

No patient-derived sequencing data are provided in this repository.

The public version does not contain:

- FASTQ, BAM or CRAM files;
- patient-derived VCF, BED, TSV or Excel files;
- patient or clinical sample identifiers;
- phenotype or other clinical information;
- internal sample lists;
- private server paths, IP addresses or hostnames;
- institutional usernames, email addresses or credentials;
- internal HUG databases or other non-public resources.

Environment-specific information is replaced by generic examples such as:

```text
/path/to/project/
/path/to/input/
/path/to/output/
/path/to/reference/genome.fasta
SAMPLE_ID
```

---

## Scope of this repository

This repository documents the **computational work performed during my Master's project** and is intended to complement the methodological description provided in the thesis.

It should not be considered a standalone clinically validated diagnostic pipeline. The internal HUG environment contains additional scripts, resources, quality-control procedures and interpretation steps that are not distributed here.

Only the caller panel and workflow components relevant to the final strategy are presented. Other SV callers were investigated and evaluated during the project but are not included when they were not retained for the final workflow.

---

## A short note on the project

A large part of this work consisted of moving from individual commands and tool-specific procedures towards workflows that were easier to rerun, understand and maintain.

One of the main lessons of the project was that choosing an SV caller cannot rely on a single benchmark score. The type and size of the event, the sequencing signal used by the caller, computational constraints and compatibility with downstream analysis all influenced the final strategy.

This repository reflects that progression from **tool evaluation to caller selection, workflow automation and downstream prioritisation**, while keeping the public version focused on the parts of the project that can be shared safely.

---

## Main software

The workflows and supporting analyses use several bioinformatics tools, including:

- **Snakemake** — workflow management
- **Manta** — structural variant calling
- **Dysgu** — structural variant calling
- **Delly** — structural variant calling
- **CNVpytor** — read-depth-based CNV detection
- **Truvari** — structural variant benchmarking
- **AnnotSV** — structural variant annotation
- **R** — generation of selected figures and descriptive summaries

Some additional components used by `SVDetection` are part of the internal HUG environment and are not distributed publicly.

---

## Master's thesis 🎓

This repository accompanies my Master's thesis completed at the **University of Geneva** in the context of the **Service of Genetic Medicine at Geneva University Hospitals (HUG)**.

**Author:** Dea Llugiqi  
**Master's programme:** Bioinformatics and Data Analysis in Biology  
**University:** University of Geneva  
**Year:** 2026

The final thesis title and bibliographic information can be added here once the manuscript is deposited.

---

## Licence

No licence is currently assigned to this repository.

Before reuse or redistribution, the ownership and licensing conditions of code developed or adapted within the host laboratory should be verified.
