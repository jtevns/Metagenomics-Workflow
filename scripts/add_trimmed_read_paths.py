import sys

line_count = 0

with open(sys.argv[1]) as f:
    for line in f:
        if line_count > 0:
            split_line = line.strip().split(",")
            split_line.append("trimmed_reads/"+split_line[0]+"/"+split_line[0]+"_trimmed_R1.fastq")
            split_line.append("trimmed_reads/"+split_line[0]+"/"+split_line[0]+"_trimmed_R2.fastq")
            print(",".join(split_line))
        else:
            print(line.strip())
        line_count = line_count + 1
