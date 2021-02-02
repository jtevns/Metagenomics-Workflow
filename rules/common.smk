# helper functions for workflow
# wildcard: 
def get_fastqs(wildcards):
    # get fq1 and fq2 from sample name
    fastqs = fastq_info.loc[(wildcards.sample), ["raw_fq1", "raw_fq2"]].dropna()
    if len(fastqs) == 2:
        return {"r1": fastqs.raw_fq1, "r2": fastqs.raw_fq2}
    else:
        return {"r1": fastqs.fq1}

def get_reads_to_map(wildcards):
    # get qced_fq1 and qced_fq2 from sample name
    fastqs = fastq_info.loc[(wildcards.sample), ["qced_fq1", "qced_fq2"]].dropna()
    if len(fastqs) == 2:
        return {"r1": fastqs.qced_fq1, "r2": fastqs.qced_fq2}

def get_refs_to_index(wildcards):
    ref_fasta = fastq_info.loc[(wildcards.ref), ["assembly"]].dropna()
    return(ref_fasta)
        
def get_mapping_outputs(map_scheme):
    outfiles = list()
    with open(map_scheme) as f:
        scheme_yaml = yaml.load(f, Loader=yaml.FullLoader)
    
    for key in scheme_yaml:
        ref = key
        samples = scheme_yaml[key]
        tmp_outfiles = ["/".join([ref,str(x) + "_mapped_sorted.bam"]) for x in samples]
        outfiles = outfiles + tmp_outfiles
    return(outfiles)

def get_assembly_outputs(assembly_scheme):
    outputs = list()
    with open(assembly_scheme) as f:
        scheme_yaml = yaml.load(f, Loader=yaml.FullLoader)
    
    outputs = ["assemblies/" + str(x) + "/assembly_stats.txt" for x in scheme_yaml.keys()]
    return(outputs) 

def get_binning_output(binning_scheme):
    outputs = list()
    with open(binning_scheme) as f:
        scheme_yaml = yaml.load(f, Loader=yaml.FullLoader)
    
    outputs = ["binning/" + str(x) + "/binstats.tsv" for x in scheme_yaml.keys()]
    return(outputs)

def get_bams(wildcards):
    all_bams = list()
    binning_scheme = config["Mapping_params"]["input"]
    #get list of int fastas to go in an assembly togethor
    with open(binning_scheme) as f:
        scheme_yaml = yaml.load(f, Loader=yaml.FullLoader)

    for sample in scheme_yaml[wildcards.assembly]:
        bam = mapping_info.loc[(sample), ["bam"]].dropna()
        if len(bam) == 1:
            all_bams += list(bam)
    return{"bams": all_bams}


def get_reads_for_assem(wildcards):
    reads = list()
    assembly_scheme = config["Mapping_params"]["input"]
    #get list of int fastas to go in an assembly togethor
    with open(assembly_scheme) as f:
        scheme_yaml = yaml.load(f, Loader=yaml.FullLoader)

    for sample in scheme_yaml[wildcards.assembly_name]:
        fastqs = fastq_info.loc[(sample), ["qced_fq1", "qced_fq2"]].dropna()
        if len(fastqs) == 2:
            reads += list(fastqs)
    return(reads)
        
def get_assem_path(wildcards):
    # get fq1 and fq2 from sample name
    assem = assem_info.loc[(wildcards.assembly), ["path"]].dropna()
    if len(assem) == 1:
        return{"assem": assem}
     