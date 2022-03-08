//subworkflows_CollapseDuplicates.nf
nextflow.enable.dsl=2

//import modules
include { collapseDuplicates } from '../modules/pyFastqDuplicateRemover'

workflow CollapseDuplicates {
  take:
  demultiplexed_reads_fastq
  
  main:
  collapseDuplicates(demultiplexed_reads_fastq)
  
  emit:
  collapsed_reads = collapseDuplicates.out
}
