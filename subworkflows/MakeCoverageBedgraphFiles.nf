//subworkflows_MakeCoverageBedgraphFiles
nextflow.enable.dsl=2

//import modules
include { makeCoverageBedgraphFiles } from '../modules/pyGTF2bedGraph'

workflow MakeCoverageBedgraphFiles {
  take:
    gtf_files
    inputID
  
  main:
     makeCoverageBedgraphFiles(gtf_files, inputID)
  
  emit:
    makeCoverageBedgraphFiles.out
}
