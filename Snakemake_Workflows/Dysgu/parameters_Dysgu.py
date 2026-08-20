"""
Dysgu
Parameters

Public anonymized template for academic/research use.
Update all paths and runtime options to match your local environment.

Contact:
deallugiqi@hotmail.com
"""

import os
from pathlib import Path
from datetime import datetime

########################################################################################################################
##> Paths to define
########################################################################################################################

program_folder = "/path/to/tools"

########################################################################################################################
##> Reference and program binaries
########################################################################################################################

reference_genome = "/path/to/reference/genome.fa"
bcftools_bin = "/path/to/bcftools/1.15.1/bin"
conda_env = "/path/to/conda/envs/dysgu_env"
conda_init = "source /path/to/miniconda/etc/profile.d/conda.sh"

########################################################################################################################
##> Other parameters
########################################################################################################################

current_user = os.environ.get("USER", "user")
date = datetime.now().strftime("%Y%m%d")
email_from = "deallugiqi@hotmail.com (DysguPipeline)"
emails_to = "deallugiqi@hotmail.com"
job_submission_platform = "LSF"

cores = 4
memory_dysgu = "16G"
memory_filter = "4G"

# SV type and filtering
SVtype = "DEL"
filter_expr = 'SVTYPE=="DEL" && (GQ>0)'