#####################################################
# Full Snakemake workflow for metagenomics
# Customize in yaml
# Que jobs on its own
# Uses singularity Containers
#####################################################
import pandas as pd
import yaml
from snakemake.utils import validate

#config file to use
configfile: "config.yaml"

# include workflows 
include: "rules/common.smk"
include: "rules/qc.smk"
include: "rules/map.smk"

# input file map
fastq_info = pd.read_csv(config["QC_Params"]["input"]).set_index("sample_name", drop=False)
validate(fastq_info, schema="./schemas/samples.schema.yaml")

# parse options and generate workflow final outputs
#if config["QC"]:
#    rule all:
#        input:
#            expand("trimmed_reads/{sample}_trimmed_{read}.fastq", sample=fastq_info.sample_name,read=["R1","R2"])
    
#TEST MAP
rule all:
    input:
        #return a list of final outputs based on config input
        get_mapping_outputs(config["Mapping_params"]["input"])
        