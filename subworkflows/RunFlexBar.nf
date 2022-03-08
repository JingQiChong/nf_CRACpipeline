//subworkflows_RunFlexbar.nf
nextflow.enable.dsl=2

//import modules
include { runFlexBar } from '../modules/flexbar'

workflow RunFlexBar {
  take:
    read
  
  main:
    runFlexBar(read)
  
  emit:
    trimmed_read = runFlexBar.out
}

