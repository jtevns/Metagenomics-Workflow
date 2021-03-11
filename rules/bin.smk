rule concoct:
    input:
        comp = "binning/{assembly}/contigs_10K.fa",
        cov = "binning/{assembly}/coverage_table.tsv"
    output:
        "binning/{assembly}/concoct_output/clustering_gt1000.csv"
    conda:
        "../envs/binning.yaml"
    resources: 
        cpus=36, mem_gb=180
    singularity:
        config['singularity']['concoct']
    shell:
        "concoct --composition_file {input.comp} --coverage_file {input.cov} -b binning/{wildcards.assembly}/concoct_output/ -t 36"

rule gen_cov:
    input:
        get_bams
    output:
        "binning/{assembly}/coverage_table.tsv"
    conda:
        "../envs/binning.yaml"
    singularity:
        config['singularity']['concoct']
    resources: 
        cpus=1, mem_gb=64
    shell:
        "python Metagenomics-Workflow/scripts/concoct_coverage_table.py binning/{wildcards.assembly}/contigs_10K.bed {input} > {output}"

rule cut_contigs:
    input:
        unpack(get_assem_path)
    output:
        bed = "binning/{assembly}/contigs_10K.bed",
        fasta = "binning/{assembly}/contigs_10K.fa"
    conda:
        "../envs/binning.yaml"
    resources: 
        cpus=1, mem_gb=8
    singularity:
        config['singularity']['concoct']
    shell:
        "python Metagenomics-Workflow/scripts/cut_up_fasta.py {input} -c 10000 -o 0 --merge_last -b {output.bed} > {output.fasta}"

rule merge_clustering:
    input:
        "binning/{assembly}/concoct_output/clustering_gt1000.csv"
    output:
        "binning/{assembly}/concoct_output/clustering_merged.csv"
    conda:
        "../envs/binning.yaml"
    resources: 
        cpus=1, mem_gb=8
    singularity:
        config['singularity']['concoct']
    shell:
        "python Metagenomics-Workflow/scripts/merge_cutup_clustering.py {input} > {output}"

rule extract_bins:
    input:
        unpack(get_assem_path),
        clustering = "binning/{assembly}/concoct_output/clustering_merged.csv"
    output:
        touch("binning/{assembly}/bin_fasta_extraction.done")
    conda:
        "../envs/binning.yaml"
    resources: 
        cpus=1, mem_gb=8
    singularity:
        config['singularity']['concoct']
    shell:
       """
       mkdir binning/{wildcards.assembly}/concoct_output/fasta_bins
       python Metagenomics-Workflow/scripts/extract_fasta_bins.py {input.assem} {input.clustering} --output_path binning/{wildcards.assembly}/concoct_output/fasta_bins
       """

rule checkm:
    input: 
        "binning/{assembly}/bin_fasta_extraction.done"
    output:
        "binning/{assembly}/binstats.tsv"
    conda:
        "../envs/binning.yaml"
    resources: 
        cpus=36, mem_gb=180
    singularity:
        config['singularity']['checkm']
    shell:
        "checkm lineage_wf binning/{wildcards.assembly}/concoct_output/fasta_bins/ binning/{wildcards.assembly}/checkm/ -x fa --tab_table -t 36 --pplacer_threads 36 -f {output}"
