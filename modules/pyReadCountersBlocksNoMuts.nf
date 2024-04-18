//Process fo running pyReadCounters block nomuts

process pyReadCountersBlocksNoMuts {
  tag "${alignment}"
  label 'process_medium'
  
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
  
  //Activate conda package 
   if (params.enable_conda) {
      conda 'bioconda::pycrac=1.5.2'    
   }
   
   //Use singularity to pull singularity image
   else if (workflow.containerEngine == 'singularity') {
      container = 'https://depot.galaxyproject.org/singularity/pycrac:1.5.2--pyh7cba7a3_0'
   }
  
  input:
  tuple val(alignment), path(bam)
  path gtf
  
  output:
  tuple val(alignment), path ("*.gtf"), emit: gtf
  tuple val(alignment), path ("*.txt"), emit: text
  
  script:
  """
  pyReadCounters.py -f ${bam} --gtf ${gtf} -v --rpkm -o ${alignment}_blocks_nomuts --file_type sam --mutations  nomuts --blocks
  """
}
