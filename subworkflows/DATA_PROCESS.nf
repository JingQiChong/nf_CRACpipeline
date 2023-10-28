// Subworkflow to trim reads and align reads
nextflow.enable.dsl=2

//import modules
include {flexbar                } from '../modules/flexbar'
include {fastqc                 } from '../modules/fastqc'
include {pyBarcodeFilter        } from '../modules/pyBarcodeFilter'
include {pyFastqDuplicateRemover} from '../modules/pyFastqDuplicateRemover'
include {novoalign              } from '../modules/novoalign'
include {bamqc                  } from '../modules/bamqc'
include {samtools_sort          } from '../modules/samtools_sort'
include {samtools_index         } from '../modules/samtools_index'

workflow DATA_PROCESS{
  take:
    read
    skip_demultiplex
  
  main:
    flexbar(read)
    if (skip_demultiplex) {
      trimmed_ch = flexbar.out.trimmed_read
    } else{
      pyBarcodeFilter(flexbar.out.trimmed_read)
      trimmed_ch = pyBarcodeFilter.out.demultiplexed_reads.flatten().map(file -> tuple(file.baseName, file))
    }
    fastqc(trimmed_ch)
    pyFastqDuplicateRemover(trimmed_ch)
    collapsed_ch = pyFastqDuplicateRemover.out
    novoalign(collapsed_ch)
    bamqc(novoalign.out.sam)
    samtools_sort(novoalign.out.sam)
    samtools_index(samtools_sort.out)
  
  emit:
    trimmed_read = trimmed_ch
    collapsed_read = collapsed_ch
    alignment = samtools_sort.out
    alignment_index = samtools_index.out.index
}