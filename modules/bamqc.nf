//process for running bamqc

process bamqc{
  tag "${alignment}"
  
  publishDir = [ 
    path: "${params.outdir}/bamqc", 
    mode: params.publish_dir_mode
  ]
  
  input:
  tuple val(alignment), path(sam)
  
  output:
  path "*.*"
  
  script:
  """
  bamqc ${sam}
  """
}