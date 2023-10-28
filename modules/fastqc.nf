//Process for running fastqc

process fastqc {
  tag "${id}"
  
  publishDir = [
    path: "${params.outdir}/demultiplexed_fastqc", 
    mode: params.publish_dir_mode
  ]
  
  input:
  tuple val(id), file(demultiplexed_reads)

  output:
  path "*.*"

  script:
  """
  fastqc ${demultiplexed_reads}
  """
}