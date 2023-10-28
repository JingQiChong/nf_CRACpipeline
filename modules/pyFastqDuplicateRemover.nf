//Process for removing fastq duplicates

process pyFastqDuplicateRemover{
  tag "${readID}"
  
  publishDir = [ 
    path: "${params.outdir}/collapsed", 
    mode: params.publish_dir_mode
  ]
  
  input:
  tuple val(readID), path(readFile)
  
  output:
  tuple val(readID), path("*.fasta"), emit: collasped_read
  
  script:
  """
  pyFastqDuplicateRemover.py -f ${readFile} -o ${readID}.fasta
  """
}