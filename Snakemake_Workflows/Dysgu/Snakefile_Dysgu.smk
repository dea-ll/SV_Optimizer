'''
:Authors: deallugiqi@hotmail.com
:Date: 17/11/2025

Snakefile for Dysgu
'''
import yaml
import parameters_Dysgu as parameters
from datetime import datetime

with open("config_Dysgu.yaml") as f:
    config = yaml.safe_load(f)

include: "rules/Dysgu.rules"
