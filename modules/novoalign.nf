//process for running novoalign

process novoalign{
  tag "${collapsed_readsID}"
  label 'process_medium'
  
  publishDir = [ 
    path: "${params.outdir}/alignment", 
    mode: params.publish_dir_mode
  ]
  
  //Activate conda package 
   if (params.enable_conda) {
      conda 'bioconda::novoalign=3.04.04'    
   }
   
   //Use singularity to pull singularity image
   else if (workflow.containerEngine == 'singularity') {
      container = 'https://depot.galaxyproject.org/singularity/novoalign:3.09.04--hc900ff6_1'
   }
  
  input:
  tuple val(collapsed_readsID), path(collapsed_readsFile)
  path(index)
  
  output:
  tuple val(collapsed_readsID),path("*.sam"), emit: sam
  
  script:
  """
  novoalign -d ${index} -o SAM -f ${collapsed_readsFile} -r Random > ${collapsed_readsID}.sam
  """
}