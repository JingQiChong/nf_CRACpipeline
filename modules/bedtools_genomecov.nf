//Process_makeGenomeCoverageBedgraph
nextflow.enable.dsl=2

//parameters
params.input = " "
params.output_dir = "results"

process makeGenomeCoverageBedgraph {
  publishDir "${params.output_dir}/bedgraph_genomecov", mode: "copy"
  
  input:
  tuple val(bamID), file(bamFile)
  
  output:
  path "*.bedgraph"
  
  script:
  """
  bedtools genomecov -bg -strand + -ibam ${bamFile} > ${bamID}_plus.bedgraph
  
  bedtools genomecov -bg -strand - -ibam ${bamFile} > ${bamID}_minus.bedgraph
  """
} 

workflow {
  sortBamfiles = channel.fromPath(params.input, checkIfExists: true).map(file -> tuple(file.baseName, file))
  makeGenomeCoverageBedgraph(sortBamfiles)
  makeGenomeCoverageBedgraph.out.view()
}
