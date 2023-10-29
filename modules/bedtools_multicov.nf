//Process for running bedtools multicov

process bedtools_multicov{
   tag "allsamples"
  
  publishDir = [ 
    path: "${params.outdir}/bedtools_multicov", 
    mode: params.publish_dir_mode
  ]
  
  input:
  path(bam)
  path(index)
  
  output:
  path "*.txt"
  
  script:
  """
  bedtools multicov -s -bed ${params.transcriptgff} -bams ${bam} >> allsample_transcriptcounts.txt
  """
}
