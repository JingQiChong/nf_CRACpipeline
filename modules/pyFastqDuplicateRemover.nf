//Process_collapseDuplicates
nextflow.enable.dsl=2

//parameters
params.input = " "
params.output_dir = "results"
  
process collapseDuplicates {
  publishDir "${params.output_dir}/collapsed", mode: "copy"
  tag "${readFile}"
  
  input:
  tuple val(readID), file(readFile)
  
  output:
  path "*.*"
  
  script:
  """
  pyFastqDuplicateRemover.py -f ${readFile} -o ${readID}.fasta
  """
} 

workflow {
  demultiplexed_reads = channel.fromPath(params.input, checkIfExists: true ).flatMap(file -> file).view()
  collapseDuplicates(demultiplexed_reads)
  collapseDuplicates.out.view()
}
  