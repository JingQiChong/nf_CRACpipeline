//subworkflows_MakeGenomeCoverageBedgraph
nextflow.enable.dsl=2

//import modules
include { makeGenomeCoverageBedgraph } from '../modules/bedtools_genomecov'

workflow MakeGenomeCoverageBedgraph {
  take:
  sortedBamfiles
  
  main:
  makeGenomeCoverageBedgraph(sortedBamfiles)
  
  emit:
  makeGenomeCoverageBedgraph.out
}
