# nf_CRACpipeline

## Introduction
nf_CRACpipeline is a nextflow workflow for processing and analyzing CRAC data.
This workflow was rewritten in Nextflow DSL2 based on an earlier version of python script, [CRAC_pipeline_SE_demult_dedup.py](https://github.com/ewallace/Ssd1_CRACanalysis_2020/blob/master/src/CRAC_pipeline_SE_demult_dedup.py) by [Edward Wallace](https://ewallace.github.io/) which was used in the paper:

>Rosemary A Bayne, Uma Jayachandran, Aleksandra Kasprowicz, Stefan Bresson, David Tollervey, Edward W J Wallace, Atlanta G Cook, Yeast Ssd1 is a non-enzymatic member of the RNase II family with an alternative RNA recognition site, Nucleic Acids Research, 2021;, gkab615, [doi: 10.1093/nar/gkab615](https://doi.org/10.1093/nar/gkab615)

## Pipeline Summary
This workflow make use of various 3rd party tools especially tools from [pyCRAC software](https://git.ecdf.ed.ac.uk/sgrannem/pycrac) by [Sander Granneman](http://sandergranneman.bio.ed.ac.uk/). A brief summary of all the tools in this pipeline and their function is listed below:

1. **Flexbar**: Trimmed forward reads
2. **pyBarcodeFilter.py**: Demultiplexed the trimmed reads 
3. **FastQC**: Evaluate the quality of the demultiplexed trimmed reads
4. **pyFastqDuplicateRemover.py**: Collapsed duplicated reads 
5. **Novoalign**: Maps the colllapsed reads to a reference genome with reference to an index file
6. **samtools**: convert sam files to bam files, sort and index bam files
7. **BamQC**: Evaluate the quality of bam/sam files
8. **bedtools genomecov**: Generate bedgraph files from sorted indexed bam files
9. **bedtools multicov**:  Counts reads to transcript features
10. **pyReadcounter.py**: Quantify the number of reads that are overlapped to the genomic features
11. **pyGTF2bedGraph**: Generate bedgraphs from gtf files
12. **pyPileup.py**: Make pileup tables of reads and deletions/mutations for a given genelist
13. **pyCalcylateFDR**: Find peaks with false discovery rates on protein-coding genes

## Installation 
Before running this pipeline, Nextflow first needs to be installed. Please follow the instruction [here](https://www.nextflow.io/) for installation.
Please make sure you have all the required dependencies listed above installed before running. 

## Quick start
To run this pipeline, use the command below
```
nextflow run main.nf \
    --reads  reads.fastq \ 
    --adapterfile adapter.fasta \ 
    --barcode Barcodes.txt \ 
    --novoindex myindexfile.novoindex \ 
    --transcriptgff myfile.gff \
    --gtf mygtffile.gtf \
    --chromosome mychromosome.lengths \ 
    --genelist mygenelist.txt \
    --genometab  mygenome.tab 
```

For more information on the arguments, simply run the command:
``` nextflow run main.nf --help ```

  

