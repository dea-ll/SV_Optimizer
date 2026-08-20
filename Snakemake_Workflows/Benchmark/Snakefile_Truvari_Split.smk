'''
Truvari Benchmarking Snakemake Pipeline

:Authors: your.email@example.org
:Date: 17/12/2025
:Purpose: Automated benchmarking of SV callers using Truvari
          Tests both RAW (unfiltered) and FILTERED (Illumina-only) truthsets
          with multiple parameter configurations
'''

import yaml
import parameters_Truvari as parameters
import os
import subprocess


with open("config_Truvari_Split.yaml") as f:
    config = yaml.safe_load(f)


# Simple extractions
TOOLS = list(config["tools"].keys())
SAMPLES = [s["name"] for s in config["samples"]]
TRUVARI_CONFIGS = config["active_configs"]
TRUTHSETS = parameters.benchmark_truthsets
FILTERED_DIR = config["paths"]["filtered_vcf_dir"]


# Mapping sample names to VCF keys for easy lookups
SAMPLE_TO_VCF_KEY = {s["name"]: s["vcf_key"] for s in config["samples"]}
SPLIT_SETS = ["DEL_50to10kb", "DEL_gt10kb", "DUP_all"]

# Auto-prepare all tool VCF files (compress + index if needed)
print("\n=== Preparing tool VCF files ===")
for tool in TOOLS:
    for sample in SAMPLES:
        vcf_key = SAMPLE_TO_VCF_KEY[sample]
        vcf_base = config["tools"][tool][vcf_key]
        vcf_gz = f"{vcf_base}.vcf.gz"
        vcf_tbi = f"{vcf_base}.vcf.gz.tbi"
        vcf = f"{vcf_base}.vcf"
        
        # Compress if needed
        if os.path.exists(vcf) and not os.path.exists(vcf_gz):
            print(f"Compressing: {vcf}")
            try:
                subprocess.run(
                    f"{parameters.conda_init} && conda activate {parameters.conda_env} && bgzip -f {vcf}",
                    shell=True,
                    check=True,
                    executable="/bin/bash"
                )
            except subprocess.CalledProcessError as e:
                print(f"Warning: Failed to compress {vcf}: {e}")
        
        # Index if needed
        if os.path.exists(vcf_gz) and not os.path.exists(vcf_tbi):
            print(f"Indexing: {vcf_gz}")
            try:
                subprocess.run(
                    f"{parameters.conda_init} && conda activate {parameters.conda_env} && tabix -f -p vcf {vcf_gz}",
                    shell=True,
                    check=True,
                    executable="/bin/bash"
                )
            except subprocess.CalledProcessError as e:
                print(f"Warning: Failed to index {vcf_gz}: {e}")

print("=== VCF preparation complete ===\n")

include: "rules/Truvari_split.rules"
