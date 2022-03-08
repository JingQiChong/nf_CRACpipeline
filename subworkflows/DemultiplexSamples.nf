//subworkflows_DemultiplexSamples.nf
nextflow.enable.dsl=2

//import modules
include { demultiplexSamples } from '../modules/pyBarcodeFilter'

workflow DemultiplexSamples {
  take:
    trimmed_read
  
  main:
    demultiplexSamples(trimmed_read)
  
  emit:
    demultiplexed_reads = demultiplexSamples.out.demultiplexed_reads
}

