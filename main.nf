//main.nf
nextflow.enable.dsl=2

//import subworkflows
include { RunFlexBar } from './subworkflows/RunFlexBar'
include { DemultiplexSamples } from './subworkflows/DemultiplexSamples'
include { RunFastQC } from './subworkflows/RunFastQC'
include { CollapseDuplicates } from './subworkflows/CollapseDuplicates'
include { RunAligner } from './subworkflows/RunAligner'

//parameters
params.input = ""
params.adapterfile = " "
params.adapterpreset = " "
params.barcode = " "
params.mismatches = 1
params.novoindex = " "
params.output_dir = "results"
read_ch = channel.fromPath(params.input, checkIfExists: true ).map(file -> tuple(file.baseName, file))

//main workflow
workflow {
     RunFlexBar(read_ch)
     DemultiplexSamples(RunFlexBar.out)
     RunFastQC(DemultiplexSamples.out)
     demultiplexed_reads_fastq = DemultiplexSamples.out.flatMap(file -> file).map(file -> tuple(file.baseName, file))
     CollapseDuplicates(demultiplexed_reads_fastq)
     RunAligner(CollapseDuplicates.out.map(file -> tuple(file.baseName, file)))
     RunAligner.out.view()
}
