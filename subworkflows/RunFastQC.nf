//subworkflows_RunFastQC.nf
nextflow.enable.dsl=2

//import modules
include { runFastQC } from '../modules/FastQC'

workflow RunFastQC {
  take:
  demultiplexed_reads
  
  main:
  runFastQC(demultiplexed_reads)
  
  emit:
  runFastQC.out
}
