rule megahit:
    input:
        get_reads_for_assem
    output:
        "{assem_name}/final.contigs.fa"
    shell:
        "megahit"