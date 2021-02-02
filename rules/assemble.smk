# Rules for adapter and quality trimming, dereplication, and interleaving
rule assemble:
    input:
        unpack(get_reads_for_assem)
    output:
        "assemblies/{assembly_name}/final.contigs.fa"
    shell:
        "megahit"

rule assembly_stats:
    input:
        "assemblies/{assembly_name}/final.contigs.fa"
    output:
        "assemblies/{assembly_name}/assembly_stats.txt"
    shell:
        "stats.sh {input} {output}"
