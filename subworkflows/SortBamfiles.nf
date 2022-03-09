//subworkflows_SortBamfiles.nf
nextflow.enable.dsl=2

//import modules
include { sortBamfiles } from '../modules/samtools_sort'

workflow SortBamfiles {
  take:
  aligned_reads
  
  main:
  sortBamfiles(aligned_reads)
  
  emit:
  sortBamfiles.out
}
