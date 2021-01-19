# Rules for adapter and quality trimming, dereplication, and interleaving
rule find_adapters:
    input:
        unpack(get_assem_read_sets)
    output:
        temp("assemblies/{assembly_name}/final.contigs.fa")
    shell:
        "bbmerge.sh "

