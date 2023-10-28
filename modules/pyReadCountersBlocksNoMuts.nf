//Process fo running pyReadCounters block nomuts

process runPyReadCountersBlocksNoMuts {
  tag "${alignedreadFile}"
  
  publishDir = [ 
    path: "${params.outdir}/pyReadCounters", 
    mode: params.publish_dir_mode
  ]
  
  input:
  tuple val(alignedreadID), file(alignedreadFile)
  
  output:
  path "*.gtf", emit: gtf
  path "*.txt", emit: text
  
  script:
  """
  pyReadCounters.py -f ${alignedreadFile} --gtf ${params.gtf} -v --rpkm -o ${alignedreadID}_blocks_nomuts --file_type sam --mutations  nomuts --blocks
  """
}
