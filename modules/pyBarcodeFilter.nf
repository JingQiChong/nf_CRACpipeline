//process for demultiplexing the sample

process pyBarcodeFilter{
  tag "${readID}"
  
  publishDir = [ 
    path: "${params.outdir}/demultiplexed", 
    mode: params.publish_dir_mode
  ]

  input:
  tuple val(readID), file(readFile)

  output:
  path "*.fastq", emit: demultiplexed_reads
  path "*.txt", emit: stats_text

  script:
  """
  pyBarcodeFilter.py -f ${readFile} -b ${params.barcode} -m ${params.mismatches}
  """
}