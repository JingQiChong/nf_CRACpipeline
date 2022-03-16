//process_novoalign.nf
nextflow.enable.dsl=2

//parameter
params.input = " "
params.output_dir = "results"
params.novoindex = " "

process alignReads {
  publishDir "${params.output_dir}/aligned_sam", mode: "copy"
  tag "${collapsed_readsFile}"
  
  input:
  tuple val(collapsed_readsID), file(collapsed_readsFile)
  
  output:
  path "*.sam"
  
  script:
  """
  novoalign -d ${params.novoindex} -o SAM -f ${collapsed_readsFile} -r Random > ${collapsed_readsID}.sam
  """
}

workflow {
  read_ch = channel.fromPath(params.input, checkIfExists: true ).map(file -> tuple(file.baseName, file))
  alignReads(read_ch)
  alignReads.out.view()
}