//process for running pyCalculateFDRs

process pyCalculateFDRs{
  tag "${id}"
  
  publishDir = [ 
    path: "${params.outdir}/pyCalculateFDRs", 
    mode: params.publish_dir_mode
  ]
  
  input:
  tuple val(id), file(counts)
  
  output:
  path "*.*"
  
  script:
  """
  pyCalculateFDRs.py -f ${counts} -o ${id}_output_FDRs.gtf -c ${params.chromosome} --gtf ${params.gtf} -a protein_coding -m 0.01 --min=5 
  """
}