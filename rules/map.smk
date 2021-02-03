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
        "mapping/{ref}/{sample}_mapped_sorted.bam"
    conda:
        "../envs/mapping.yaml"
    threads: 10
    shell:
        """
        bwa mem {input.index} {input.r1} {input.r2} | samtools sort -o {output} -
        """
rule index_bam:
    input:
         "mapping/{ref}/{sample}_mapped_sorted.bam"
    output:
         "mapping/{ref}/{sample}_mapped_sorted.bam.bai"
    conda:
        "../envs/mapping.yaml"
    shell:
        "samtools index {input}"

rule index_ref:
    input:
        unpack(get_refs_to_index)
        # unpack results in
        # ref_fasta
    output:
        "mapping/{ref}/{ref}.fa.bwt",
        "mapping/{ref}/{ref}.fa.amb",
        "mapping/{ref}/{ref}.fa.ann",
        "mapping/{ref}/{ref}.fa.pac",
        "mapping/{ref}/{ref}.fa.sa",
        "mapping/{ref}/{ref}.fa"
    conda:
        "../envs/mapping.yaml"
    threads: 10
    shell:
        """
        mkdir -p mapping/{wildcards.ref}
        cp {input} mapping/{wildcards.ref}/{wildcards.ref}.fa
        bwa index mapping/{wildcards.ref}/{wildcards.ref}.fa
        """
        

