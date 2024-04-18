//process for running pyCalculateFDRs

process pyCalculateFDRs{
  tag "${id}"
  label 'process_medium'
  
  publishDir = [ 
    path: "${params.outdir}/pyCalculateFDRs", 
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
  tuple val(id), path(counts)
  path chromosome
  path gtf
  
  output:
  path "*.*"
  
  script:
  """
  pyCalculateFDRs.py -f ${counts} -o ${id}_output_FDRs.gtf -c ${chromosome} --gtf ${gtf} -a protein_coding -m 0.01 --min=5 
  """
}