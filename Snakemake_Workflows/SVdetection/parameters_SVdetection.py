"""
SV detection Snakemake pipeline
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
root = "/path/to/bams/PE_SR_Tools"

singularity_image = "/path/to/images/AnnotSV.sif"

########################################################################################################################
##> Reference and program binaries
########################################################################################################################

########################################################################################################################
##> 1 - Data formatter
########################################################################################################################

conda_init = "/path/to/miniconda/etc/profile.d/conda.sh"
conda_env = "/path/to/conda/envs/sv_pipeline"

########################################################################################################################
##> 2 - Aggregation
########################################################################################################################

aggregation_env = "/path/to/conda/envs/aggregation_env"
svf_database_script = "/path/to/SV_Detection_and_Filtering/Create_SVF_database.pl"

########################################################################################################################
##> 3 - AnnotSV
########################################################################################################################

annotsv_annotations = program_folder + "/AnnotSV/3.0.7/Annotations_Human"
AnnotSV_sif = program_folder + "/AnnotSV/3.3.4/AnnotSV.sif"

########################################################################################################################
##> 4 - Filtration
########################################################################################################################

panels_file = "/path/to/panel_directory/panels_WGS.txt"
sv_filtering_root = "/path/to/SV_Detection_and_Filtering/sv_filtering"

########################################################################################################################
##> Other parameters
########################################################################################################################

tool_dir = {
    "manta.del_max10kb": "Manta",
    "cnvnator.del":      "CNVnator-del",
    "cnvnator.dup":      "CNVnator-dup",
    "delly.inv":         "Delly",
}

annot_version = "3.0.7"

current_user = os.environ.get("USER", "user")
date = datetime.now().strftime("%d-%m-%Y")
email_from = "deallugiqi@hotmail.com (SVdetectionSMKPipeline)"
emails_to = "deallugiqi@hotmail.com"
job_submission_platform = "LSF"