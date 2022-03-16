//process_runPyCalculateFDRs
nextflow.enable.dsl=2

//parameters
params.input = " "
params.chromosome = " "
params.gtf = " "
params.output_dir = "results"

process runPyCalculateFDRs {
  publishDir "${params.output_dir}/pyCalculateFDRs_analyses", mode: "copy"
  tag "${count_readsFile}"
  
  input:
  path count_readsFile
  val count_readsID
  
  output:
  path "*.*"
  
  script:
  """
  pyCalculateFDRs.py -f ${count_readsFile} -o ${count_readsID}_output_FDRs.gtf -c ${params.chromosome} --gtf ${params.gtf} -a protein_coding -m 0.01 --min=5 
  """
} 

workflow {
  count_reads_gtfFile = channel.fromPath(params.input, checkIfExists: true)
  count_reads_gtfID = channel.fromPath(params.input, checkIfExists: true).map(file -> file.baseName).map({ it.replaceAll("_count_output_reads","") })
  runPyCalculateFDRs(count_reads_gtfFile, count_reads_gtfID)
  runPyCalculateFDRs.out.view()
}