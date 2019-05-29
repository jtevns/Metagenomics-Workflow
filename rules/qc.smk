# Rules for adapter and quality trimming, dereplication, and interleaving
rule find_adapters:
    input:
        unpack(get_fastqs)
    output:
        temp("trimmed_reads/{sample}_adapters.fa")
    shell:
        "bbmerge.sh "

rule bbduk_pe:
    input:
        unpack(get_fastqs),
        adapters = "trimmed_reads/{sample}_adapters.fa"
    output:
        t1 = temp("trimmed_reads/{sample}_trimmed_r1.fastq"),
        t2 = temp("trimmed_reads/{sample}_trimmed_r2.fastq")
    shell:
        """
        bbduk in={input.r1} \ #input
              in2={input.r2} \
              out={output.t1} \ #output
              out2={output.t2} \
              ref={input.adapters} \ #adapters to look for
              ktrim=r \ #trim to the right
              k=23 \ #contamination must be atleast 23bp
              mink=11 \ # check read ends for contamination length 11 to 23
              hdist=1 \ # hamming distance for storage (changes amount of stored kmers)
              tpe \ # trip adapters by overlap 
              tbo \ # trim read pairs to the same length
              qtrim=rl \ # quality trim both ends
              trimq=20 \ # q20 for assembly
              maq=10 \ # read must have avg of q10
        """

rule derep_reads:
    input:
        "trimmed_reads/{sample}_trimmed_{read}.fastq"
    output:
        temp("trimmed_reads/{sample}_trimmed_dereplicated_{read}.fasta")
    shell:
        "perl ./scripts/DerepTools/dereplicate.pl -fq {input} -out {output} -outfmt fasta"

rule interleave:
    input:
        r1 = "trimmed_reads/{sample}_trimmed_dereplicated_r1.fasta",
        r2 = "trimmed_reads/{sample}_trimmed_dereplicated_r2.fasta"
    output:
        "trimmed_reads/{sample}_trimmed_dereplicated_int.fasta"
    shell:
        "./scripts/interleave.pl -fwd {input.r1} -rev {input.r2} -o {output}"

rule fastqc:
    input:
        "trimmed_reads/{sample}_trimmed_dereplicated_int.fasta"
    output:
        html="trimmed_reads/{sample}_trimmed_dereplicated_int.html",
        zip="trimmed_reads/{sample}_trimmed_dereplicated_int.zip"
    shell:
        "fastqc {input}"

rule multiqc:
    input:
        expand("trimmed_reads/{sample}_trimmed_dereplicated_int.html", sample=sample_info.sample_name)
    output:
        "multiqc.html"
    shell:
        "multqc trimmed_reads/"

rule read_loss_plots:
    input:
        expand("trimmed_reads/{sample}_trimmed_{read}.fastq", sample=sample_info.sample_name,read=["r1","r2"]),
        expand("trimmed_reads/{sample}_trimmed_dereplicated_int.fasta", sample=sample_info.sample_name),
        expand("trimmed_reads/{sample}_trimmed_dereplicated_{read}.fasta",sample=sample_info.sample_name,read=["r1","r2"])
    output:
        "read_removal_report.txt"
