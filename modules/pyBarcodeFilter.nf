//process for demultiplexing the sample

process pyBarcodeFilter{
  tag "${readID}"
  label 'process_medium'
  
  publishDir = [
    [ 
      path: "${params.outdir}/demultiplexed", 
      mode: params.publish_dir_mode,
      pattern: "*fastq"
    ],
    [ 
      path: "${params.outdir}/demultiplexed/stats", 
      mode: params.publish_dir_mode,
      pattern: "*txt"
    ]
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
  path barcode

  output:
  path "*.fastq", emit: demultiplexed_reads
  path "*.txt", emit: stats_text

  script:
  """
  pyBarcodeFilter.py -f ${readFile} -b ${barcode} -m ${params.mismatches}
  """
}