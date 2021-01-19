# helper functions for workflow
# wildcard: 
def get_fastqs(wildcards):
    # get fq1 and fq2 from sample name
    fastqs = fastq_info.loc[(wildcards.sample), ["raw_fq1", "raw_fq2"]].dropna()
    if len(fastqs) == 2:
        return {"r1": fastqs.fq1, "r2": fastqs.fq2}
    else:
        return {"r1": fastqs.fq1}

def get_reads_for_assem(wildcards):
    #get list of int fastas to go in an assembly togethor
    sample_names = assembly_info.loc[(wildcards.assem_name),"samples"]
    suffix = "_trimmed_dereplicated_int.fasta"
    prefix = "trimmed_reads/"
    read_files = [prefix+x+suffix for x in sample_names.split(":")]
    return(read_files)

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