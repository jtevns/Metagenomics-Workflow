#####################################################
# Full Snakemake workflow for metagenomics
# Customize in yaml
# Que jobs on its own
#####################################################

import pandas as pd
from snakemake.utils import validate

# validation of input files
configfile: "config.yaml"
#validate(config, schema="../schemas/config.schema.yaml")

#samples and fastqs
sample_info = pd.read_csv(config["samples"]).set_index("sample_name", drop=False)
validate(sample_info, schema="./schemas/samples.schema.yaml")

#assemblies and coassemblies to make
assembly_info = pd.read_csv(config["assemblies"]).set_index('assembly_name', drop=False)
validate(assembly_info, schema="./schemas/assembly.schema.yaml")

#final files for each major step
rule all:
    input:
        "multiqc.html",
        "read_removal_report.txt",
        expand("{assem_name}/final.contigs.fa",assem_name=assembly_info.assembly_name)

#TODO: Helper functions and verification of input
include: "rules/helper_funcs.smk"
#TODO: QC
include: "rules/qc.smk"
#TODO: Assemble
include: "rules/assemble.smk"
#TODO: Map
#TODO: make cove table
#TODO: bin
#TODO: dereplicate
