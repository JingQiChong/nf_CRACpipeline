//Process_runMultiCovTranscript

process runMultiCovTranscript {
   tag "${alignment}"
  
  publishDir = [ 
    path: "${params.outdir}/multicov_analyses", 
    mode: params.publish_dir_mode
  ]
  
  input:
  tuple val(alignment), path(bam)
  tuple val(alignment), path(index)
  
  output:
  path "*.txt"
  
  script:
  """
  bedtools multicov -s -bed ${params.transcriptgff} -bams ${bam} >> allsample_transcriptcounts.txt
  """
}
