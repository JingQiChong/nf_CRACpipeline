//process for running flexbar

process flexbar {
  tag "${readID}"
  
  publishDir = [
    [
      path: "${params.outdir}/flexbar_trimmed", 
    mode: params.publish_dir_mode,
      pattnern: "*.fastq"
    ],
    [
      path: "${params.outdir}/pyReadCounters/logs", 
      mode: params.publish_dir_mode,
      pattern: "*log"
    ]
  ]
  
  input:
  tuple val(readID), file(readFile)
  
  output:
  tuple val(readID), path("*_trimmed.fastq"), emit: trimmed_read
  tuple val(readID), path("*log"), emit: log

  script:
  def args = ""
  if( params.adapterfile != null) {
    args += "--adapters ${params.adapterfile}"
  }
  
  else if( params.adapterpreset != null) {
    args += "--aa ${params.adapterpreset}"
  }
  
  """
  flexbar -r ${readFile} --output-reads ${readID}_trimmed.fastq -n 10 -q TAIL -qf i1.8 -qt 30 --qtrim-post-removal -ao 5 ${args}
  """
}