//main.nf
nextflow.enable.dsl=2

//show help message
if(params.help) {
   include {HelpMessage} from './modules/help'
   HelpMessage()
   exit 0
}

//import subworkflows
include {DATA_PROCESS} from './subworkflows/DATA_PROCESS'
include { bedtools_genomecov} from './modules/bedtools_genomecov'
include { RunMultiCovTranscript } from './subworkflows/RunMultiCovTranscript'
include { RunPyReadCounters } from './subworkflows/RunPyReadCounters'
include { RunPyReadCountersBlocksNoMuts } from './subworkflows/RunPyReadCountersBlocksNoMuts'
include { MakeCoverageBedgraphFiles  } from './subworkflows/MakeCoverageBedgraphFiles'
include { RunPyPileup } from './subworkflows/RunPyPileup'
include { RunPyCalculateFDRs } from './subworkflows/RunPyCalculateFDRs'


//main workflow
workflow {
     read_ch = channel.fromPath(params.reads, checkIfExists: true ).map(file -> tuple(file.baseName, file))
     DATA_PROCESS(read_ch,params.skip_demultiplex)
     bedtools_genomecov(DATA_PROCESS.out.alignment)
     sortedbamfiles = DATA_PROCESS.out.alignment.collect()
     bamfilesindex = DATA_PROCESS.out.alignment_index.collect()
     RunMultiCovTranscript(sortedbamfiles, bamfilesindex)
     RunPyReadCounters(DATA_PROCESS.out.alignment)
     RunPyReadCountersBlocksNoMuts(DATA_PROCESS.out.alignment)
     InputID = RunPyReadCountersBlocksNoMuts.out.map(file -> file.baseName).map({ it.replaceAll("_count_output_cDNAs","") })
     MakeCoverageBedgraphFiles(RunPyReadCountersBlocksNoMuts.out, InputID)
     RunPyPileup(DATA_PROCESS.out.alignment)
     count_reads_gtfID = RunPyReadCounters.out.map(file -> file.baseName).map({ it.replaceAll("_count_output_reads","") })
     RunPyCalculateFDRs(RunPyReadCounters.out, count_reads_gtfID)
}