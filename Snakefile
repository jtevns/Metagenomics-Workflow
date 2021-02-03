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
container: "docker://continuumio/miniconda3:4.4.10"
# include workflows 
include: "rules/common.smk"
include: "rules/qc.smk"
include: "rules/map.smk"
include: "rules/assemble.smk"
include: "rules/bin.smk"

# input file map
fastq_info = pd.read_csv(config["QC_Params"]["csv_info"]).set_index("sample_name", drop=False)

assem_info = pd.read_csv(config["Assembly_Params"]["csv_info"]).set_index("name", drop=False)

mapping_info = pd.read_csv(config["Mapping_Params"]["csv_info"]).set_index("ref", drop=False)


# parse options and generate workflow final outputs
#if config["QC"]:
#    rule all:
#        input:
#            
    
#TEST MAP
rule all:
    input:
        #return a list of final outputs based on config input for mapping
        #get_mapping_outputs(config["Mapping_Params"]["scheme"])
        # qc
        #expand("trimmed_reads/{sample}/{sample}_trimmed_{read}.fastq", sample=fastq_info.sample_name,read=["R1","R2"])
        # assembly
        #get_assembly_outputs(config["Assembly_Params"]["scheme"])
        # binning
         get_binning_output(config["Binning_Params"]["scheme"])
