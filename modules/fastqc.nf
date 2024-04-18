//Process for running fastqc

process fastqc {
  tag "${id}"
  label 'process_medium'
  
  publishDir = [
    path: "${params.outdir}/demultiplexed_fastqc", 
    mode: params.publish_dir_mode
  ]
  
  //Activate conda package 
   if (params.enable_conda) {
      conda 'bioconda::fastqc=0.11.9'    
   }
   
   //Use singularity to pull singularity/docker image
   else if (workflow.containerEngine == 'singularity') {
      container = 'https://depot.galaxyproject.org/singularity/fastqc:0.11.9--0'
   }
  
  input:
  tuple val(id), path(demultiplexed_reads)

  output:
  path "*.*"

  script:
  """
  fastqc ${demultiplexed_reads}
  """
}