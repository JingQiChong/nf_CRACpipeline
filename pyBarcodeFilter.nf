//process_demultiplexSamples
nextflow.enable.dsl=2

//parameters
params.input = " "
params.barcode = " "
params.mismatches = 1

process demultiplexSamples {
  publishDir "demultiplexed", mode: "copy"

  input:
  path read

  output:
  path "*.*"

  script:
  """
  pyBarcodeFilter.py -f ${read} -b ${params.barcode} -m ${params.mismatches}
  """
}

workflow {
  read_ch = channel.fromPath(params.input, checkIfExists: true )
  demultiplexSamples(read_ch)
  demultiplexSamples.out.view()
}
