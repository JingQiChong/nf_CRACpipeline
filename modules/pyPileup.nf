//process for running pyPileup

process pyPileup {
  tag "${alignment}"
  label 'process_medium'
  
  publishDir = [ 
    path: "${params.outdir}/pyPileup", 
    mode: params.publish_dir_mode
  ]
  
  //Activate conda package 
   if (params.enable_conda) {
      conda 'bioconda::pycrac=1.5.2'    
   }
   
   //Use singularity to pull singularity image
   else if (workflow.containerEngine == 'singularity') {
      container = 'https://depot.galaxyproject.org/singularity/pycrac:1.5.2--pyh7cba7a3_0'
   }
  
  input:
  tuple val(alignment), path(bam)
  path genometab
  path gtf
  path genelist
  
  output:
  path "*.txt"
  
  when:
  params.genelist != null
  
  script:
  """
  pyPileup.py -f ${bam} -o ${alignment}_pileups.txt --tab ${genometab} --gtf ${gtf} --file_type=sam -g ${genelist}
  """
} 