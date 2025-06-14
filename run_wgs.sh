#!/bin/bash

# === CONFIGURATION ===
SAMPLE_FASTQ1="sample_R1.fastq.gz"
SAMPLE_FASTQ2="sample_R2.fastq.gz"
REF_GENOME="GRCh38.fa"
KNOWN_SITES1="dbsnp.vcf.gz"
KNOWN_SITES2="Mills_and_1000G_gold_standard.indels.vcf.gz"
PICARD="picard.jar"

# Output prefix
OUT_PREFIX="sample_wgs"

# === 1. Quality Control ===
fastqc $SAMPLE_FASTQ1 $SAMPLE_FASTQ2 -o fastqc_results/

# === 2. Trimming ===
fastp -i $SAMPLE_FASTQ1 -I $SAMPLE_FASTQ2 -o trimmed_R1.fastq.gz -O trimmed_R2.fastq.gz --detect_adapter_for_pe --thread 4 --html fastp_report.html

# === 3. Alignment ===
bwa mem -t 8 $REF_GENOME trimmed_R1.fastq.gz trimmed_R2.fastq.gz > aln.sam

# === 4. Sort and Mark Duplicates ===
samtools sort -@ 4 -o sorted.bam aln.sam
samtools index sorted.bam

java -Xmx8g -jar $PICARD MarkDuplicates I=sorted.bam O=dedup.bam M=metrics.txt
samtools index dedup.bam

# === 5. Base Quality Score Recalibration (BQSR) ===
gatk BaseRecalibrator -I dedup.bam -R $REF_GENOME --known-sites $KNOWN_SITES1 --known-sites $KNOWN_SITES2 -O recal_data.table
gatk ApplyBQSR -R $REF_GENOME -I dedup.bam --bqsr-recal-file recal_data.table -O recalibrated.bam

# === 6. Variant Calling ===
gatk HaplotypeCaller -R $REF_GENOME -I recalibrated.bam -O raw_variants.vcf.gz

# === 7. Variant Filtering ===
gatk VariantFiltration -R $REF_GENOME -V raw_variants.vcf.gz -O filtered_variants.vcf.gz --filter-expression "QD < 2.0 || FS > 60.0 || MQ < 40.0" --filter-name "my_filters"