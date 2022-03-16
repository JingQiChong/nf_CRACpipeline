//process_demultiplexSamples
nextflow.enable.dsl=2

//parameters
params.input = " "
params.barcode = " "
params.mismatches = 1
params.output_dir = "results"

process demultiplexSamples {
  publishDir "${params.output_dir}/demultiplexed", mode: "copy"
  tag "${read}"

  input:
  path read

  output:
  path "*.fastq", emit: demultiplexed_reads
  path "*.txt", emit: stats_text

  script:
  """
  pyBarcodeFilter.py -f ${read} -b ${params.barcode} -m ${params.mismatches}
  """
}

workflow {
  read_ch = channel.fromPath(params.input, checkIfExists: true )
  demultiplexSamples(read_ch)
  demultiplexSamples.out.demultiplexed_reads.view()
}
