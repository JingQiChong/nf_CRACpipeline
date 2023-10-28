//Process for running PyReadCounters

process runPyReadCounters {
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
  pyReadCounters.py -f ${alignedreadFile} --gtf ${params.gtf} -v --rpkm -o ${alignedreadID} --file_type sam
  """
}
