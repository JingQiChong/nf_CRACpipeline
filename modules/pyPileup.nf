//process_runPileup

process runPyPileup {
  tag "${alignedreadFile}"
  
  publishDir = [ 
    path: "${params.outdir}/pyPileup", 
    mode: params.publish_dir_mode
  ]
  
  input:
  tuple val(alignedreadID), file(alignedreadFile)
  
  output:
  path "*.*"
  
  when:
  params.genelist != null
  
  script:
  """
  pyPileup.py -f ${alignedreadFile} -o ${alignedreadID}_pileups.txt --tab ${params.genometab} --gtf ${params.gtf} --file_type=sam -g ${params.genelist}
  """
} 