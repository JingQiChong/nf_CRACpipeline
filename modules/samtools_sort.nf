//Process for running samtools sort and view

process samtools_sort{
  tag "${alignment}"
  
  publishDir = [ 
    path: "${params.outdir}/alignment", 
    mode: params.publish_dir_mode
  ]
  
  input:
  tuple val(alignment), path(sam)
  
  output:
  tuple val(alignment),path("*.bam"), emit: bam
  
  script:
  """
  samtools view -b ${sam} | samtools sort -@ 3 -O bam -o ${alignment}.bam -T ./tmp -
  """
}