//main.nf
nextflow.enable.dsl=2

//show help message
if(params.help) {
   include {HelpMessage} from './modules/help'
   HelpMessage()
   exit 0
}

//run information
log.info"""

====================================================
      DNA Methylation Array Designer (DMAD)
====================================================
Input/output options
  input                   : $params.reads
  output directory        : $params.outdir

Nextflow options
  launchDir               : $workflow.launchDir
  workDir                 : $workflow.workDir
  profile                 : $workflow.profile"""
if (workflow.containerEngine){
  log.info """  container               : $workflow.containerEngine"""
}

log.info"""
config options
  configFiles             : $workflow.configFiles

Max job request options
  max cpu                 : $params.max_cpus
  max mem                 : $params.max_memory
  max rt                  : $params.max_time
====================================================

"""

//import subworkflows
include {CRAC_PROCESS} from './subworkflows/CRAC_PROCESS'
include {CRAC_ANALYSIS} from './subworkflows/CRAC_ANALYSIS'

//main workflow
workflow {
     read_ch = channel.fromPath(params.reads, checkIfExists: true ).map(file -> tuple(file.SimpleName, file))
     CRAC_PROCESS(read_ch,params.skip_demultiplex)
     CRAC_ANALYSIS(CRAC_PROCESS.out.alignment,CRAC_PROCESS.out.alignment_index)
}