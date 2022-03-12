//subworkflows_RunPyReadCounters
nextflow.enable.dsl=2

//import modules
include { runPyReadCounters } from '../modules/pyReadCounters'

workflow RunPyReadCounters {
  take:
    aligned_read
  
  main:
    runPyReadCounters(aligned_read)
  
  emit:
    runPyReadCounters.out
}
