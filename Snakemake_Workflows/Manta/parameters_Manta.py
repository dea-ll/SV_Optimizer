"""
Manta
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

program_folder = "/path/to/tools/"
reference_genome = "/path/to/reference/genome.fa"

########################################################################################################################
##> Reference and program binaries
########################################################################################################################

reference_bed = program_folder + "Manta/hg19.main-chromosomes.bed.gz"
manta_bin = program_folder + "Manta/manta-1.6.0/bin/"
samtools_bin = program_folder + "samtools/"
bcftools_bin = program_folder + "bcftools/1.15.1/bin/"
bedops_bin = program_folder + "BEDOPS/bin-v2.4.40/"

########################################################################################################################
##> Other parameters
########################################################################################################################

current_user = os.environ.get("USER", "user")
date = datetime.now().strftime("%Y%m%d")
email_from = "deallugiqi@hotmail.com (MantaPipeline)"
emails_to = "deallugiqi@hotmail.com"
job_submission_platform = "LSF"

SVtype = "DEL"
vcf_filter = 'FILTER=="PASS" && (GQ>0) && SVTYPE=="DEL" && SVLEN<0 && SVLEN>-10000'

MANTA_VERSION = "1.6.0"
SAMTOOLS_VERSION = "1.10"
BCFTOOLS_VERSION = "1.15.1"
BEDOPS_VERSION = "2.4.40"