# Rules for adapter and quality trimming, dereplication, and interleaving
rule find_adapters:
    input:
        unpack(get_fastqs)
    output:
        "trimmed_reads/{sample}_adapters.fa"
    shell:
        "bbbmerge.sh in={input} outa={output}"

rule bbduk_pe:
    input:
        unpack(get_fastqs),
        adapters = "trimmed_reads/{sample}_adapters.fa"
    output:
        t1 = "trimmed_reads/{sample}_trimmed_R1.fastq",
        t2 = "trimmed_reads/{sample}_trimmed_R2.fastq"
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