//Process_sortBamFiles
nextflow.enable.dsl=2

//parameters
params.input = " "
params.output_dir = "results"

process sortBamfiles {
  publishDir "${params.output_dir}/aligned_bamsorted", mode: "copy"
  tag "${alignedreadFile}"
  
  input:
  tuple val(alignedreadID), file(alignedreadFile)
  
  output:
  path "*.bam"
  
  script:
  """
  samtools view -b ${alignedreadFile} | samtools sort -@ 3 -O bam -o ${alignedreadID}.bam -T ./tmp -
  """
} 

workflow {
   aligned_reads = channel.fromPath(params.input, checkIfExists: true).map(file -> tuple(file.baseName, file))
   sortBamfiles(aligned_reads)
   sortBamfiles.out.view()
}
