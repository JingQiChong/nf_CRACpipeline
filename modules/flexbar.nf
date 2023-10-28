//process for running flexbar

qflags = "-q TAIL -qf i1.8 -qt 30 --qtrim-post-removal"

process flexbar {
  tag "${readID}"
  
  publishDir = [ 
    path: "${params.outdir}/flexbar_trimmed", 
    mode: params.publish_dir_mode
  ]
  
  
  input:
  tuple val(readID), file(readFile)
  
  output:
  tuple val(readID), path("*_trimmed.fastq"), emit: trimmed_read

  script:
  if( params.adapterfile != " ") {
    """
    flexbar -r ${readFile} --output-reads ${readID}_trimmed.fastq -n 10 ${qflags} -ao 5 --adapters ${params.adapterfile} 
    """
  }
  
  else if( params.adapterpreset != " ") {
    """
    flexbar -r ${readFile} --output-reads ${readID}_trimmed.fastq -n 10 ${qflags} -ao 5 --aa ${params.adapterpreset}
    """
  }
  
  else {
    """
    flexbar -r ${readFile} --output-reads ${readID}_trimmed.fastq -n 10 ${qflags} -ao 5
    """
  }
}