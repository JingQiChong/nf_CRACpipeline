//main.nf
nextflow.enable.dsl=2

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

//parameters
params.input = ""
params.adapterfile = " "
params.adapterpreset = " "
params.barcode = " "
params.mismatches = 1
params.novoindex = " "
params.transcriptgff = " "
params.gtf = " "
params.output_dir = "results"
read_ch = channel.fromPath(params.input, checkIfExists: true ).map(file -> tuple(file.baseName, file))

//main workflow
workflow {
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
}