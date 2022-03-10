//Process_runMultiCovTranscript
nextflow.enable.dsl=2

//parameters
params.input = " "
params.index = " "
params.transcriptgff = " "
params.output_dir = "results"

process runMultiCovTranscript {
  publishDir "${params.output_dir}/multicov_analyses", mode: "copy"
  
  input:
  path sortedbamfile
  path bamfileindex
  
  output:
  path "*.txt"
  
  script:
  """
  bedtools multicov -s -bed ${params.transcriptgff} -bams ${sortedbamfile} >> allsample_transcriptcounts.txt
  """
} 

workflow {
  sortedBamfiles = channel.fromPath(params.input, checkIfExists: true)
  bamfileindex = channel.fromPath(params.index, checkIfExists: true) 
  runMultiCovTranscript(sortedBamfiles, bamfileindex)
  runMultiCovTranscript.out.view()
}
