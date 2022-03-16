//process_runPileup
nextflow.enable.dsl=2

//parameters
params.input = " "
params.gtf = " "
params.genometab = " "
params.genelist = " "
params.output_dir = "results"

process runPyPileup {
  publishDir "${params.output_dir}/pyPileup_analyses", mode: "copy"
  tag "${alignedreadFile}"
  
  input:
  tuple val(alignedreadID), file(alignedreadFile)
  
  output:
  path "*.*"
  
  script:
  """
  pyPileup.py -f ${alignedreadFile} -o ${alignedreadID}_pileups.txt --tab ${params.genometab} --gtf ${params.gtf} --file_type=sam -g ${params.genelist}
  """
} 

workflow {
  aligned_reads = channel.fromPath(params.input, checkIfExists: true).map(file -> tuple(file.baseName, file))
  runPyPileup(aligned_reads)
  runPyPileup.out.view()
}