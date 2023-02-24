//main.nf
nextflow.enable.dsl=2

//show help message
if(params.help) {
   include {HelpMessage} from './modules/help'
   HelpMessage()
   exit 0
}

//import subworkflows
include { RunFlexBar } from './subworkflows/RunFlexBar'
include { DemultiplexSamples } from './subworkflows/DemultiplexSamples'
include { RunFastQC } from './subworkflows/RunFastQC'
include { CollapseDuplicates } from './subworkflows/CollapseDuplicates'
include { RunAligner } from './subworkflows/RunAligner'
include { RunBamQC } from './subworkflows/RunBamQC'
include { SortBamfiles } from './subworkflows/SortBamfiles'
include { IndexBamfiles } from './subworkflows/IndexBamfiles'
include { MakeGenomeCoverageBedgraph } from './subworkflows/MakeGenomeCoverageBedgraph'
include { RunMultiCovTranscript } from './subworkflows/RunMultiCovTranscript'
include { RunPyReadCounters } from './subworkflows/RunPyReadCounters'
include { RunPyReadCountersBlocksNoMuts } from './subworkflows/RunPyReadCountersBlocksNoMuts'
include { MakeCoverageBedgraphFiles  } from './subworkflows/MakeCoverageBedgraphFiles'
include { RunPyPileup } from './subworkflows/RunPyPileup'
include { RunPyCalculateFDRs } from './subworkflows/RunPyCalculateFDRs'


//main workflow
workflow {
     read_ch = channel.fromPath(params.reads, checkIfExists: true ).map(file -> tuple(file.baseName, file))
     RunFlexBar(read_ch)
     DemultiplexSamples(RunFlexBar.out)
     RunFastQC(DemultiplexSamples.out)
     demultiplexed_reads_fastq = DemultiplexSamples.out.flatten().map(file -> tuple(file.baseName, file)) 
     CollapseDuplicates(demultiplexed_reads_fastq)
     RunAligner(CollapseDuplicates.out.map(file -> tuple(file.baseName, file)))
     RunBamQC(RunAligner.out.collect())
     SortBamfiles(RunAligner.out.map(file -> tuple(file.baseName, file)))
     IndexBamfiles(SortBamfiles.out)
     MakeGenomeCoverageBedgraph(SortBamfiles.out.map(file -> tuple(file.baseName, file)))
     sortedbamfiles = SortBamfiles.out.collect()
     bamfilesindex = IndexBamfiles.out.collect()
     RunMultiCovTranscript(sortedbamfiles, bamfilesindex)
     RunPyReadCounters(RunAligner.out.map(file -> tuple(file.baseName, file)))
     RunPyReadCountersBlocksNoMuts(RunAligner.out.map(file -> tuple(file.baseName, file)))
     InputID = RunPyReadCountersBlocksNoMuts.out.map(file -> file.baseName).map({ it.replaceAll("_count_output_cDNAs","") })
     MakeCoverageBedgraphFiles(RunPyReadCountersBlocksNoMuts.out, InputID)
     RunPyPileup(RunAligner.out.map(file -> tuple(file.baseName, file)))
     count_reads_gtfID = RunPyReadCounters.out.map(file -> file.baseName).map({ it.replaceAll("_count_output_reads","") })
     RunPyCalculateFDRs(RunPyReadCounters.out, count_reads_gtfID)
}