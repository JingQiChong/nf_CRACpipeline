//process for running bedtools genomecov

process bedtools_genomecov{
  tag "${alignment}"
  label 'process_single'
  
  publishDir = [ 
    path: "${params.outdir}/bedgraph_genomecov", 
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
  tuple val(alignment), path(bam)
  
  output:
  path "*.bedgraph"
  
  script:
  """
  bedtools genomecov -bg -strand + -ibam ${bam} > ${alignment}_plus.bedgraph
  
  bedtools genomecov -bg -strand - -ibam ${bam} > ${alignment}_minus.bedgraph
  """
}