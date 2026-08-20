'''
:Authors: deallugiqi@hotmail.com
:Date: 10/10/2025

Snakefile for Manta
'''
import yaml
import parameters_Manta as parameters
from datetime import datetime

with open("config_Manta.yaml") as f:
    config = yaml.safe_load(f)

include: "rules/Manta.rules"
