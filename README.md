### HINTON_LAB_TK_122


How to deconvolute single-end RNAseq reads from sequencing library prepared following Debbie's protocol based on the following paper: 

[Avraham R, Haseley N, Fan A, Bloom-Ackermann Z, Livny J, Hung DT. A highly multiplexed and sensitive RNA-seq protocol for simultaneous analysis of host and pathogen transcriptomes. Nat Protoc. 2016 Aug;11(8):1477-91. doi: 10.1038/nprot.2016.090. Epub 2016 Jul 21. PMID: 27442864.](https://pubmed.ncbi.nlm.nih.gov/27442864/)

```
module load perl
perl ./deconvolute_reads.pl -s SampleSheet.csv -f sampleX.fastq.gz
```

The script assumes that the first 8 bp of the read corresponds to the sample index.

