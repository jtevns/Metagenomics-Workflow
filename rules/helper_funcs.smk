# helper functions for workflow
# wildcard: 
def get_fastqs(wildcards):
    # get fq1 and fq2 from sample name
    fastqs = sample_info.loc[(wildcards.sample), ["fq1", "fq2"]].dropna()
    print(fastqs)
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
    print(read_files)
    return(read_files)
