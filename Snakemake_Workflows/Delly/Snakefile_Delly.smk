'''
:Authors: deallugiqi@hotmail.com
:Date: 16/10/2025

Snakefile for Delly
'''
import yaml
import parameters_Delly as parameters
from datetime import datetime

envvars:
    "PATH",
    "LD_LIBRARY_PATH"

with open("config_Delly.yaml") as f:
    config = yaml.safe_load(f)

include: "rules/Delly.rules"
