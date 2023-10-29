//main.nf
nextflow.enable.dsl=2

//show help message
if(params.help) {
   include {HelpMessage} from './modules/help'
   HelpMessage()
   exit 0
}

//import subworkflows
include {CRAC_PROCESS} from './subworkflows/CRAC_PROCESS'
include {CRAC_ANALYSIS} from './subworkflows/CRAC_ANALYSIS'



//main workflow
workflow {
     read_ch = channel.fromPath(params.reads, checkIfExists: true ).map(file -> tuple(file.baseName, file))
     CRAC_PROCESS(read_ch,params.skip_demultiplex)
     CRAC_ANALYSIS(CRAC_PROCESS.out.alignment,CRAC_PROCESS.out.alignment_index)
}