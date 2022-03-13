//subworkflows_RunPyCalculateFDRs
nextflow.enable.dsl=2

//import modules
include { runPyCalculateFDRs } from '../modules/pyCalculateFDRs'

workflow RunPyCalculateFDRs {
  take:
    count_reads_gtfFile
    count_reads_gtfID
  
  main:
    runPyCalculateFDRs(count_reads_gtfFile, count_reads_gtfID)
  
  emit:
    runPyCalculateFDRs.out
}
