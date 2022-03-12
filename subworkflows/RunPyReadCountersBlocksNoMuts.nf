//subworkflows_RunPyReadCountersBlocksNoMuts
nextflow.enable.dsl=2

//import modules
include { runPyReadCountersBlocksNoMuts } from '../modules/pyReadCountersBlocksNoMuts'

workflow RunPyReadCountersBlocksNoMuts {
  take:
    aligned_read
  
  main:
    runPyReadCountersBlocksNoMuts(aligned_read)
  
  emit:
    runPyReadCountersBlocksNoMuts.out.gtf
}

