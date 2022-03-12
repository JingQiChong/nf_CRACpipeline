//Process_runPyReadCounters
nextflow.enable.dsl=2

//parameters
params.input = " "
params.gtf = " "
params.output_dir = "results"

process runPyReadCounters {
  publishDir "${params.output_dir}/pyReadCounters_analyses", mode: "copy"
  
  input:
  tuple val(alignedreadID), file(alignedreadFile)
  
  output:
  path "*.*"
  
  script:
  """
  pyReadCounters.py -f ${alignedreadFile} --gtf ${params.gtf} -v --rpkm -o ${alignedreadID} --file_type sam
  """
} 

workflow {
  aligned_reads = channel.fromPath(params.input, checkIfExists: true).map(file -> tuple(file.baseName, file))
  runPyReadCounters(aligned_reads)
  runPyReadCounters.out.view()
}
