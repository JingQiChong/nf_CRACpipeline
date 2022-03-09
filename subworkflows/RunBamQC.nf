//subworkflows_RunBamQC.nf
nextflow.enable.dsl=2

//import modules
include { runBamQC } from '../modules/BamQC'

workflow RunBamQC {
  take:
  aligned_reads
  
  main:
  runBamQC(aligned_reads)
  
  emit:
  runBamQC.out
}
