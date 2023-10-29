// Subworkflow to trim reads and align reads
nextflow.enable.dsl=2

//import modules
include {bedtools_genomecov        } from '../modules/bedtools_genomecov'
include {bedtools_multicov         } from '../modules/bedtools_multicov'
include {pyReadCounters            } from '../modules/pyReadCounters'
include {pyReadCountersBlocksNoMuts} from '../modules/pyReadCountersBlocksNoMuts'
include {pyPileup                  } from '../modules/pyPileup'
include {pyCalculateFDRs           } from '../modules/pyCalculateFDRs'
include {pyGTF2bedGraph            } from '../modules/pyGTF2bedGraph'

workflow CRAC_ANALYSIS{
  take:
    bam
    bam_index
  
  main:
     bedtools_genomecov(bam)
     allbam_ch = bam.map{id,file -> file}.collect()
     allbam_index_ch = bam_index.map{id,file -> file}.collect()
     bedtools_multicov(allbam_ch, allbam_index_ch)
     pyReadCounters(bam)
     pyReadCountersBlocksNoMuts(bam)
     pyGTF2bedGraph(pyReadCountersBlocksNoMuts.out.gtf)
     pyPileup(bam)
     pyCalculateFDRs(pyReadCounters.out.gtf)
  
  emit:
    cov = bedtools_genomecov.out
}