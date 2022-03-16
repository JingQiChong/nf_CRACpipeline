//Process_runPyReadCountersBlocksNoMuts
nextflow.enable.dsl=2

//parameters
params.input = " "
params.gtf = " "
params.output_dir = "results"

process runPyReadCountersBlocksNoMuts {
  publishDir "${params.output_dir}/pyReadCountersBlocksNoMuts_analyses", mode: "copy"
  tag "${alignedreadFile}"
  
  input:
  tuple val(alignedreadID), file(alignedreadFile)
  
  output:
  path "*.gtf", emit: gtf
  path "*.txt", emit: text
  
  script:
  """
  pyReadCounters.py -f ${alignedreadFile} --gtf ${params.gtf} -v --rpkm -o ${alignedreadID}_blocks_nomuts --file_type sam --mutations  nomuts --blocks
  """
} 

workflow {
  aligned_reads = channel.fromPath(params.input, checkIfExists: true).map(file -> tuple(file.baseName, file))
  runPyReadCountersBlocksNoMuts(aligned_reads)
  runPyReadCountersBlocksNoMuts.out.gtf.view()
}
