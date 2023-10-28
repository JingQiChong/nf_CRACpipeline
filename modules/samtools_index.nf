//Process for running samtools index

process samtools_index{
  tag "${alignment}"
  
  publishDir = [ 
    path: "${params.outdir}/alignment", 
    mode: params.publish_dir_mode
  ]
  
  input:
  tuple val(alignment), path(sam)
  
  output:
  tuple val(alignment),path("*.bai"), emit: index
  
  script:
  """
  samtools index ${sam}
  """
} 