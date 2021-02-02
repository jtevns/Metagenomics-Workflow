rule map_pairs:
    input:
        #unpack results in 
        # r1:
        # r2:
        unpack(get_reads_to_map),
        "mapping/{ref}/{ref}.fa.bwt",
        "mapping/{ref}/{ref}.fa.amb",
        "mapping/{ref}/{ref}.fa.ann",
        "mapping/{ref}/{ref}.fa.pac",
        "mapping/{ref}/{ref}.fa.sa",
        index = "mapping/{ref}/{ref}.fa"
        
    output:
        "binning/{ref}/{sample}_mapped_sorted.bam"
    shell:
        """
        bwa mem {input.index} {input.r1} {input.r2} | samtools sort -o {output} -
        """
rule index_ref:
    input:
        unpack(get_refs_to_index)
        # unpack results in
        # ref_fasta
    output:
        "binning/{ref}/{ref}.fa.bwt",
        "binning/{ref}/{ref}.fa.amb",
        "binning/{ref}/{ref}.fa.ann",
        "binning/{ref}/{ref}.fa.pac",
        "binning/{ref}/{ref}.fa.sa",
        "binning/{ref}/{ref}.fa"
    shell:
        """
        mkdir -p binning/{wildcards.ref}
        cd binning/{wildcards.ref}
        ln -s {input} ./{wildcards.ref}.fa
        bwa index ./{wildcards.ref}.fa
        """
        

