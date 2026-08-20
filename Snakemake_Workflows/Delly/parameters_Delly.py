"""
Delly
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

Delly_bin = "/path/to/delly/bin/delly"
samtools_bin = program_folder + "samtools/"
bcftools_bin = program_folder + "bcftools/1.15.1/bin/"
bedops_bin = program_folder + "BEDOPS/bin-v2.4.40/"
exclude_template = "/path/to/delly/excludeTemplates/human.hg19.excl.noChr.tsv"
htslib_path = "/path/to/delly/htslib"

########################################################################################################################
##> Other parameters
########################################################################################################################

current_user = os.environ.get("USER", "user")
date = datetime.now().strftime("%Y%m%d")
email_from = "deallugiqi@hotmail.com (DellyPipeline)"
emails_to = "deallugiqi@hotmail.com"
job_submission_platform = "LSF"

SVtype = "DEL"
# vcf_filter_inv = 'MAPQ>30 && PE>5 && FILTER=="PASS" && ALT~"INV"'

vcf_filter_inv = 'SVTYPE=="DEL" && (GQ>0)'
# for INV:
# 'MAPQ>30 && PE>5 && FILTER=="PASS" && ALT~"INV"'

delly_min_quality = 30

SAMTOOLS_VERSION = "1.10"
BCFTOOLS_VERSION = "1.15.1"
BEDOPS_VERSION = "2.4.40"