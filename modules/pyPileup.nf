//process for running pyPileup

process pyPileup {
  tag "${alignment}"
  
  publishDir = [ 
    path: "${params.outdir}/pyPileup", 
    mode: params.publish_dir_mode
  ]
  
  input:
  tuple val(alignment), file(bam)
  
  output:
  path "*.txt"
  
  when:
  params.genelist != null
  
  script:
  """
  pyPileup.py -f ${bam} -o ${alignment}_pileups.txt --tab ${params.genometab} --gtf ${params.gtf} --file_type=sam -g ${params.genelist}
  """
} 