//subworkflows_IndexBamfiles.nf
nextflow.enable.dsl=2

//import modules
include { indexBamfiles } from '../modules/samtools_index'

workflow IndexBamfiles {
  take:
  bamreads
  
  main:
  indexBamfiles(bamreads)
  
  emit:
  indexBamfiles.out
}
