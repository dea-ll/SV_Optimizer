"""
CNVpytor
Parameters

Public anonymized template for academic/research use.
Update all paths and runtime options to match your local environment.
"""

import os
from pathlib import Path
from datetime import datetime

########################################################################################################################
##> Paths to define
########################################################################################################################

program_folder = "/path/to/tools/"
bcftools_bin = program_folder + "bcftools/1.15.1/bin/"

########################################################################################################################
##> Reference and program binaries
########################################################################################################################

reference_genome = "/path/to/reference/genome.fa"
cnvpytor_env = "/path/to/conda/envs/cnvpytor_env"
conda_profile = "source /path/to/miniconda/etc/profile.d/conda.sh"

########################################################################################################################
##> Other parameters
########################################################################################################################

current_user = os.environ.get("USER", "user")
date = datetime.now().strftime("%Y%m%d")
email_from = "user@example.org"
emails_to = "user@example.org"
job_submission_platform = "LSF"

cores = 4
memory_cnvpytor = "16G"
memory_filter = "4G"

# SV type and filtering
bin_size = 1500
SVtype = "DEL"

SVTYPE_DEL = "DEL"
SVTYPE_DUP = "DUP"

vcf_filter_del = 'FILTER=="PASS" && SVTYPE=="DEL" && abs(SVLEN)>=10000'
vcf_filter_dup = 'FILTER=="PASS" && SVTYPE=="DUP" && abs(SVLEN)>=50'