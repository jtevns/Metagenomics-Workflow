localrules: assembly_stats
# Rules for adapter and quality trimming, dereplication, and interleaving
rule assemble:
    input:
        unpack(get_reads_for_assem)
    output:
        "assemblies/{assembly_name}/Megahit_meta-sensitive_out/final.contigs.fa"
    conda:
        "../envs/megahit.yaml"
    resources: 
        cpus=36, mem_gb=180
    singularity:
        config['singularity']['megahit']
    shell:
        """
        megahit -1 {input.r1} -2 {input.r2} -t {resources.cpus} --presets meta-sensitive -o assemblies/{wildcards.assembly_name}/Megahit_meta-sensitive_out/tmp/
        mv assemblies/{wildcards.assembly_name}/Megahit_meta-sensitive_out/tmp/* assemblies/{wildcards.assembly_name}/Megahit_meta-sensitive_out/
        rm -rf assemblies/{wildcards.assembly_name}/Megahit_meta-sensitive_out/tmp/
        """

rule assembly_stats:
    input:
        "assemblies/{assembly_name}/Megahit_meta-sensitive_out/final.contigs.fa"
    output:
        "assemblies/{assembly_name}/assembly_stats.txt"
    conda:
        "../envs/bbmap.yaml"
    singularity:
        config['singularity']['bbtools']
    shell:
        "stats.sh {input} > {output}"
