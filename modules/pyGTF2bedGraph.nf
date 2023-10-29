//process for running pyGTF2bedGraph

process pyGTF2bedGraph{
  tag "${id}"
  
  publishDir = [ 
    path: "${params.outdir}/pyGTF2bedGraph", 
    mode: params.publish_dir_mode
  ]
  
  input:
  tuple val(id), file(counts)
  
  output:
  path "*.bedgraph"
  
  script:
  """
  pyGTF2bedGraph.py --gtf ${counts} --count -v --permillion -o ${id} -c ${params.chromosome}
  """
}
