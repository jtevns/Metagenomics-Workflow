rule concoct:
    input:
        comp = "binning/{assembly}/contigs_10K.fa",
        cov = "binning/{assembly}/coverage_table.tsv"
    output:
        "binning/{assembly}/concoct_output/clustering_gt1000.csv"
    shell:
        "concoct --composition_file {input.comp} --coverage_file {input.cov} -b binning/{wildcards.assembly}/concoct_output/"

rule gen_cov:
    input:
        unpack(get_bams),
        bed = "binning/{assembly}/contigs_10K.bed"
    output:
        "binning/{assembly}/coverage_table.tsv"
    shell:
        "concoct_coverage_table.py {input.bed} {input.bams} > {output}"

rule cut_contigs:
    input:
        unpack(get_assem_path)
    output:
        bed = "binning/{assembly}/contigs_10K.bed",
        fasta = "binning/{assembly}/contigs_10K.fa"
    shell:
        "cut_up_fasta.py {input} -c 10000 -o 0 --merge_last -b {output.bed} > {output.fasta}"

rule merge_clustering:
    input:
        "binning/{assembly}/concoct_output/clustering_gt1000.csv"
    output:
        "binning/{assembly}/concoct_output/clustering_merged.csv"
    shell:
        "merge_cutup_clustering.py {input} > {output}"

rule extract_bins:
    input:
        unpack(get_assem_path),
        clustering = "binning/{assembly}/concoct_output/clustering_merged.csv"
    output:
        touch("binning/{assembly}/bin_fasta_extraction.done")
    shell:
       """
       mkdir binning/{wildcards.assembly}/concoct_output/fasta_bins
       extract_fasta_bins.py {input.assem} {input.clustering} --output_path binning/{wildcards.assembly}/concoct_output/fasta_bins
       """

rule checkm:
    input: 
        "binning/{assembly}/bin_fasta_extraction.done"
    output:
        "binning/{assembly}/binstats.tsv"
    shell:
        "checkm lineage_wf binning/{wildcards.assembly}/concoct_output/fasta_bins/ binning/{wildcards.assembly}/checkm/ --tab_table -t --pplacer_threads -f {output}"