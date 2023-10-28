//process for running novoalign

process novoalign{
  tag "${collapsed_readsID}"
  
  publishDir = [ 
    path: "${params.outdir}/alignment", 
    mode: params.publish_dir_mode
  ]
  
  input:
  tuple val(collapsed_readsID), file(collapsed_readsFile)
  
  output:
  tuple val(collapsed_readsID),path("*.sam"), emit: sam
  
  script:
  """
  novoalign -d ${params.novoindex} -o SAM -f ${collapsed_readsFile} -r Random > ${collapsed_readsID}.sam
  """
}