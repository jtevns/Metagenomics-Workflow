# Rules for adapter and quality trimming, dereplication, and interleaving
rule find_adapters:
    input:
        unpack(get_fastqs)
    output:
        "trimmed_reads/{sample}/{sample}_adapters.fa"
    conda:
        "../envs/bbmap.yaml"
    resources: 
        cpus=1, mem_gb=4
    singularity:
        config['singularity']['bbtools']
    shell:
        """
        bbmerge.sh in1={input.r1} in2={input.r2} outa={output}
        """

rule bbduk_pe:
    input:
        unpack(get_fastqs),
        adapters = "trimmed_reads/{sample}/{sample}_adapters.fa"
    output:
        t1 = "trimmed_reads/{sample}/{sample}_trimmed_R1.fastq",
        t2 = "trimmed_reads/{sample}/{sample}_trimmed_R2.fastq"
    conda:
        "../envs/bbmap.yaml"
    resources: 
        cpus=1, mem_gb=8
    singularity:
        config['singularity']['bbtools']
    shell:
        """
        bbduk.sh in1={input.r1} in2={input.r2} out1={output.t1} out2={output.t2} ref={input.adapters} ktrim=r k=23 mink=11 hdist=1 tpe tbo qtrim=rl trimq=20 maq=10
        """
