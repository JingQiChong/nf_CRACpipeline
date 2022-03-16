//Process_makeCoverageBedgraphFiles
nextflow.enable.dsl=2

//parameters
params.input = " "
params.chromosome = " "
params.output_dir = "results"

process makeCoverageBedgraphFiles {
  publishDir "${params.output_dir}/bedgraph_files", mode: "copy"
  tag "${inputFile}"
  
  input:
  path inputFile
  val inputID
  
  output:
  path "*.bedgraph"
  
  script:
  """
  pyGTF2bedGraph.py --gtf ${inputFile} --count -v --permillion -o ${inputID} -c ${params.chromosome}
  """
} 

workflow {
  gtf_files = channel.fromPath(params.input, checkIfExists: true)
  inputID = channel.fromPath(params.input, checkIfExists: true).map(file -> file.baseName).map({ it.replaceAll("_count_output_cDNAs","") })
  makeCoverageBedgraphFiles(gtf_files, inputID)
  makeCoverageBedgraphFiles.out.view()
}
