//process_runFlexbar.nf
nextflow.enable.dsl=2

//parameters
params.input = ""
params.adapterfile = " "
params.adapterpreset = " "
params.output_dir = "results"

qflags = "-q TAIL -qf i1.8 -qt 30 --qtrim-post-removal"


process runFlexBar {
  publishDir "${params.output_dir}/flexbar_trimmed", mode: "copy"
  
  input:
  path read
  
  output:
  path "*_trimmed.fastq"

  script:
  if( params.adapterfile != " ") {
    """
    flexbar -r ${read} --output-reads ${read}_trimmed.fastq -n 10 ${qflags} -ao 5 --adapters ${params.adapterfile} 
    """
  }
  
  else if( params.adapterpreset != " ") {
    """
    flexbar -r ${read} --output-reads ${read}_trimmed.fastq -n 10 ${qflags} -ao 5 --aa ${params.adapterpreset}
    """
  }
  
  else {
    """
    flexbar -r ${read} --output-reads ${read}_trimmed.fastq -n 10 ${qflags} -ao 5
    """
  }
}


workflow {
  read_ch = channel.fromPath(params.input, checkIfExists: true )
  runFlexBar(read_ch)
  runFlexBar.out.view()
}
