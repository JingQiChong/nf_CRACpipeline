//Process for running bedtools multicov

process bedtools_multicov{
   tag "allsamples"
   label 'process_single'
  
  publishDir = [ 
    path: "${params.outdir}/bedtools_multicov", 
    mode: params.publish_dir_mode
  ]
  
  //Activate conda package 
   if (params.enable_conda) {
      conda 'bioconda::bedtools=2.31.0'    
   }
   
   //Use singularity to pull singularity image
   else if (workflow.containerEngine == 'singularity') {
      container = 'https://depot.galaxyproject.org/singularity/bedtools:2.31.0--hf5e1c6e_2'
   }
  
  input:
  path(bam)
  path(index)
  path(transcriptgff)
  
  output:
  path "*.txt"
  
  script:
  """
  bedtools multicov -s -bed ${transcriptgff} -bams ${bam} >> allsample_transcriptcounts.txt
  """
}
