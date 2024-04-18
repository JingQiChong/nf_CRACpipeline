//process for running pyGTF2bedGraph

process pyGTF2bedGraph{
  tag "${id}"
  label 'process_medium'
  
  publishDir = [ 
    path: "${params.outdir}/pyGTF2bedGraph", 
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
  
  output:
  path "*.bedgraph"
  
  script:
  """
  pyGTF2bedGraph.py --gtf ${counts} --count -v --permillion -o ${id} -c ${chromosome}
  """
}
