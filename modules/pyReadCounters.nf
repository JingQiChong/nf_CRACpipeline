//Process for running PyReadCounters

process pyReadCounters {
  tag "${alignment}"
  
  publishDir = [
    [
      path: "${params.outdir}/pyReadCounters", 
      mode: params.publish_dir_mode,
      pattnern: "*.gtf"
    ],
    [
      path: "${params.outdir}/pyReadCounters/stats", 
      mode: params.publish_dir_mode,
      pattern: "*statistics*"
    ],
    [
      path: "${params.outdir}/pyReadCounters/hit", 
      mode: params.publish_dir_mode,
      pattern: "*hittable*"
    ]
    
  ]
  
  input:
  tuple val(alignment), file(bam)
  
  output:
  tuple val(alignment), path ("*.gtf"), emit: gtf
  tuple val(alignment), path ("*.txt"), emit: text
  
  script:
  """
  pyReadCounters.py -f ${bam} --gtf ${params.gtf} -v --rpkm -o ${alignment} --file_type sam
  """
}
