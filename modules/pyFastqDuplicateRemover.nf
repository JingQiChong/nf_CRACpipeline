//Process for removing fastq duplicates

process pyFastqDuplicateRemover{
  tag "${readID}"
  label 'process_medium'
  
  publishDir = [ 
    path: "${params.outdir}/collapsed", 
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
  tuple val(readID), path(readFile)
  
  output:
  tuple val(readID), path("*.fasta"), emit: collasped_read
  
  script:
  """
  pyFastqDuplicateRemover.py -f ${readFile} -o ${readID}.fasta
  """
}