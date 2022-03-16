//process_BamQC.nf
nextflow.enable.dsl=2

process runBamQC {
  publishDir "${params.output_dir}/aligned_bamqc", mode: "copy"
  tag "${aligned_reads}"
  
  input:
  path aligned_reads
  
  output:
  path "*.*"
  
  script:
  """
  bamqc ${aligned_reads}
  """
}

//parameters
params.input = " "
params.output_dir = "results"

workflow {
  aligned_ch = channel.fromPath(params.input, checkIfExists: true )
  runBamQC(aligned_ch)
  runBamQC.out.view()
}