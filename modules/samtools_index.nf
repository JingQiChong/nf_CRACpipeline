//Process_sortBamFiles
nextflow.enable.dsl=2

//parameters
params.input = " "
params.output_dir = "results"

process indexBamfiles {
  publishDir "${params.output_dir}/aligned_bamsorted", mode: "copy"
  
  input:
  path bamsorted
  
  output:
  path "*.bam.bai"
  
  script:
  """
  samtools index ${bamsorted}
  """
} 

workflow {
   aligned_reads = channel.fromPath(params.input, checkIfExists: true)
   indexBamfiles(aligned_reads)
   indexBamfiles.out.view()
}
