//Help message for understanding the parameter

def HelpMessage(){
   log.info"""
    
   Hello! Below are the description of the arguments available for running in the nf_CRACpipeline: 
   
   Flexbar:
   --reads [file]          The path to your fastq read files which is also the input of the pipeline. Default=None
   --adapterfile [file]    The path to your file containing the 3' adapter sequences for trimming the reads using flexbar. Default=None
   --adapterpreset [name]  Select one out of four adapter preset (TruSeq, SmallRNA, Methyl, Ribo, Nextera, and NexteraMP). Requires Flexbar version 3.4.0 or later. Default=None
   
   pyBarcodeFilter.py:
   --barcodes [file]       The path to the file containing the list of barcodes. If you do not provide a barcode file, the demultiplexing step will fail. Default=None
   --mismatches [value]    Specified the number of mismatches you allow for demultiplexing. Default=1  
   
   novoalign: 
   --novoindex [file]      The path to your novoindex file. Default=None
   
   pyReadCounters.py, pyGTF2bedGraph.py, pyCalculateFDRs.py, pyPileup.py:
   --gtf [file]            The path to your gtf annotation file, metavar="rRNA.gtf". Default=None
   --chromosome [file]     The path to your chromosome length file.Default=None
   --genelist [file]       Provide a genelist file for pileup analysis, with one gene name per line. Default=None
   --genometab [file]      Provide a genome sequence file in pyCRAC tab format for pileup analysis. Default=None
   
   bedtools multicov:
   --transcriptgff [file]  Provide a gff file containing only transcript sequences for count analysis. Default=None
   
   Output:
   --output_dir [name]     The name of output directory where the results will be saved. Default="results"  
   
   """
}