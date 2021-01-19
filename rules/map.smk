rule map_pairs:
    input:
        #unpack results in 
        # r1:
        # r2:
        unpack(get_reads_to_map),
        "{ref}/{ref}.fa.bwt",
        "{ref}/{ref}.fa.amb",
        "{ref}/{ref}.fa.ann",
        "{ref}/{ref}.fa.pac",
        "{ref}/{ref}.fa.sa",
        index = "{ref}/{ref}.fa"
        
    output:
        "{ref}/{sample}_mapped_sorted.bam"
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
        "{ref}/{ref}.fa.bwt",
        "{ref}/{ref}.fa.amb",
        "{ref}/{ref}.fa.ann",
        "{ref}/{ref}.fa.pac",
        "{ref}/{ref}.fa.sa",
        "{ref}/{ref}.fa"
    shell:
        """
        mkdir -p {wildcards.ref}
        cd {wildcards.ref}
        ln -s {input} ./{wildcards.ref}.fa
        bwa index ./{wildcards.ref}.fa
        """
        

