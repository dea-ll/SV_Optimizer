'''
:Author: deallugiqi@hotmail.com
:Date: 04/05/2026

Master Snakefile for:
  1) DataFormater
  2) Aggregation
  3) AnnotSV
  4) SV filtering
'''

import yaml
import  parameters_SVdetection as parameters
from datetime import datetime

with open("config_SVdetection.yaml") as f:
    config = yaml.safe_load(f)


include: "rules/1-DataFormater.rules"
include: "rules/2-Aggregation.rules"
include: "rules/3-Annotation.rules"
include: "rules/4-Filtration.rules"




       
