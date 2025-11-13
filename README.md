WGS Pipeline - GATK Best Practices (Simplified)
===============================================

This is a basic Whole Genome Sequencing (WGS) pipeline shell script following GATK Best Practices.

Steps included:
1. Quality Control (FastQC)
2. Trimming (fastp)
3. Alignment (BWA-MEM)
4. Sort & Mark Duplicates (samtools, picard)
5. Base Quality Score Recalibration (GATK)
6. Variant Calling (GATK HaplotypeCaller)
7. Variant Filtering (GATK VariantFiltration)

Requirements:
- fastqc
- fastp
- bwa
- samtools
- picard (picard.jar)
- gatk (version 4+)

Usage:
- Edit variables in run_wgs.sh to point to your sample files, reference genome, and resources
- Run: bash run_wgs.sh

Note:
- Reference genome should be indexed for bwa and gatk
- Known sites VCFs required for BQSR step
