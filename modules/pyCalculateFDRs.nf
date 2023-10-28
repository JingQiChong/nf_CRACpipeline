//process for running pyCalculateFDRs

process runPyCalculateFDRs {
  tag "${count_readsFile}"
  
  publishDir = [ 
    path: "${params.outdir}/pyCalculateFDRs_", 
    mode: params.publish_dir_mode
  ]
  
  input:
  path count_readsFile
  val count_readsID
  
  output:
  path "*.*"
  
  script:
  """
  pyCalculateFDRs.py -f ${count_readsFile} -o ${count_readsID}_output_FDRs.gtf -c ${params.chromosome} --gtf ${params.gtf} -a protein_coding -m 0.01 --min=5 
  """
}