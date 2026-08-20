'''
:Authors: deallugiqi@hotmail.com
:Date: 05/12/2025

Snakefile for CNVpytor
'''
import yaml
import parameters_CNVpytor as parameters
from datetime import datetime

with open("config_CNVpytor.yaml") as f:
    config = yaml.safe_load(f)

include: "rules/CNVpytor.rules"
