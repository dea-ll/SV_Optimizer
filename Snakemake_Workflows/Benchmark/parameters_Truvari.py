"""
Truvari Parameters

contact: your.email@example.org
Genetics Laboratory
Institution
"""

import os
from pathlib import Path
from datetime import datetime

#######################################################################################################################
##> Paths to define
########################################################################################################################

program_folder = "/path/to/programs/"
reference_genome = "/path/to/reference/genome.fasta"

########################################################################################################################
##> Tool binaries
########################################################################################################################

bcftools_bin = program_folder + "bcftools/1.15.1/bin/"
truvari_env = "/path/to/conda/environment"

########################################################################################################################
##> Conda/Environment
########################################################################################################################

conda_init = "source /path/to/miniconda/etc/profile.d/conda.sh"
conda_env = "/path/to/conda/environment"

########################################################################################################################
##> Results directories
########################################################################################################################

results_base = "/path/to/benchmark/results"
results_dir_raw = results_base + "/RAW"
results_dir_filtered = results_base + "/FILTERED"
results_dir_splited = results_base + "/SPLITED"

########################################################################################################################
##> Benchmark configurations
########################################################################################################################

# Generic truthset names (mapped in config_Truvari.yaml)
benchmark_truthsets = ["RAW", "FILTERED"]

########################################################################################################################
##> System info
########################################################################################################################

current_user = os.environ.get("USER", "username")
date = datetime.now().strftime("%Y%m%d")
email_from = "your.email@example.org (TruvariPipeline)"
emails_to = "your.email@example.org"