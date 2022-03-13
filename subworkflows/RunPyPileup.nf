//subworkflows_RunPyPileup
nextflow.enable.dsl=2

//import modules
include { runPyPileup } from '../modules/pyPileup'

workflow RunPyPileup {
  take:
    aligned_reads
  
  main:
    runPyPileup(aligned_reads)
  
  emit:
    runPyPileup.out
}

