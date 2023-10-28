//Process to run bedtools genomecov

process bedtools_genomecov{
  tag "${alignment}"
  
  publishDir = [ 
    path: "${params.outdir}/bedgraph_genomecov", 
    mode: params.publish_dir_mode
  ]
  
  input:
  tuple val(alignment), path(bam)
  
  output:
  path "*.bedgraph"
  
  script:
  """
  bedtools genomecov -bg -strand + -ibam ${bam} > ${alignment}_plus.bedgraph
  
  bedtools genomecov -bg -strand - -ibam ${bam} > ${alignment}_minus.bedgraph
  """
}