//Process for running samtools sort and view

process samtools_sort{
  tag "${alignment}"
  label 'process_medium'
  
  publishDir = [ 
    path: "${params.outdir}/alignment", 
    mode: params.publish_dir_mode
  ]
  
  //Activate conda package 
   if (params.enable_conda) {
      conda 'bioconda::samtools=1.16.1'    
   }
   
   //Use singularity to pull singularity image
   else if (workflow.containerEngine == 'singularity') {
      container = 'https://depot.galaxyproject.org/singularity/samtools:1.16.1--h6899075_1'
   }
  
  input:
  tuple val(alignment), path(sam)
  
  output:
  tuple val(alignment),path("*.bam"), emit: bam
  
  script:
  """
  samtools view -b ${sam} | samtools sort -@ 3 -O bam -o ${alignment}.bam -T ./tmp -
  """
}