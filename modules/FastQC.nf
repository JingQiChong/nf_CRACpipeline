//Process_runFastQC
nextflow.enable.dsl=2

//parameters
params.input = " "
params.output_dir = "results"

process runFastQC {
  publishDir "${params.output_dir}/demultiplexed_fastqc", mode: "copy"
  
  input:
  path demultiplexed_reads

  output:
  path "*.*"

  script:
  """
  fastqc ${demultiplexed_reads}
  """
}

workflow {
  demultiplexed_ch = channel.fromPath(params.input, checkIfExists: true )
  runFastQC(demultiplexed_ch)
  runFastQC.out.view()
}
