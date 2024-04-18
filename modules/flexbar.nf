//process for running flexbar

process flexbar {
  tag "${readID}"
  label 'process_medium'
  
  publishDir = [
    [
      path: "${params.outdir}/flexbar_trimmed", 
      mode: params.publish_dir_mode,
      pattnern: "*.fastq"
    ],
    [
      path: "${params.outdir}/flexbar_trimmed/logs", 
      mode: params.publish_dir_mode,
      pattern: "*log"
    ]
  ]
  
  //Activate conda package 
   if (params.enable_conda) {
      conda 'bioconda::flexbar=3.5.0'    
   }
   
   //Use singularity to pull singularity image
   else if (workflow.containerEngine == 'singularity') {
      container = 'https://depot.galaxyproject.org/singularity/flexbar:3.5.0--hf92b6da_10'
   }

   
  input:
  tuple val(readID), path(readFile)
  path adapterfile
  
  output:
  tuple val(readID), path("*_trimmed.fastq"), emit: trimmed_read
  tuple val(readID), path("*log"), emit: log

  script:
  def args = ""
  if( params.adapterfile != null) {
    args = "--adapters ${adapterfile}"
  }
  
  else if( params.adapterpreset != null) {
    args = "--aa ${params.adapterpreset}"
  }
  
  """
  flexbar -r ${readFile} --output-reads ${readID}_trimmed.fastq -n 10 -q TAIL -qf i1.8 -qt 30 --qtrim-post-removal -ao 5 ${args}
  """
}