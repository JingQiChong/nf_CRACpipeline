//subworkflows_RunAligner.nf
nextflow.enable.dsl=2

//import modules
include { alignReads } from '../modules/novoalign'

workflow RunAligner {
  take:
  collapsed_reads
  
  main:
  alignReads(collapsed_reads)
  
  emit:
  aligned_sam = alignReads.out
}
