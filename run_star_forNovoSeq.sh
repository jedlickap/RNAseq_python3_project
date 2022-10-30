#!/bin/bash
    set -e
    set -u
    set -o pipefail

fq_dir=$1
ref_fa=$2
ref_gtf=$3
echo "Fastq_folder: $1"
fq_files=($(ls ${fq_dir}*fq.gz))
echo ${fq_files[@]}
echo "Reference fasta: $2"
echo "Reference GTF: $3"

# FASTQC
#if [[ -d "1_Fastqc/" ]]
#then
#	rm -rf 1_Fastqc/
#fi

#mkdir 1_Fastqc
#fastqc -o 1_Fastqc -t 4 ${fq_files[@]}
	
# STAR_INDEX
ref_dir=$(echo $ref_fa | cut -f 1 -d '/')

if [[ -d "${ref_dir}/star_index" ]]
then
	rm -rf ${ref_dir}/star_index
fi

~/Documents/Soft/STAR/source/STAR --runThreadN 4 \
	--runMode genomeGenerate \
	--genomeDir ${ref_dir}/star_index \
	--genomeSAindexNbases 11 \
	--limitGenomeGenerateRAM 124544990592 \
	--genomeFastaFiles ${ref_fa} \
	--sjdbGTFfile ${ref_gtf} \
	--sjdbOverhang 99

# STAR_MAPPING

# uniq_sample_ids
if [[ -f "sample_ids.txt" ]]
then 
	rm -r sample_ids.txt
fi

for fq in ${fq_files[@]}
do
	echo $fq | cut -f 2 -d "/" | cut -f 1 -d "_" | sort | uniq
done | sort | uniq > sample_ids.txt

if [[ -d "2_STAR_mapping/" ]]
then
	rm -rf 2_STAR_mapping/
fi

# star_mapping
for sid in $(cat sample_ids.txt)
do
	out_dir=2_STAR_mapping/${sid}
	R1=${fq_dir}${sid}_1_subsampled.fq.gz
	R2=${fq_dir}${sid}_2_subsampled.fq.gz
	/home/pavel/Documents/Soft/STAR/source/STAR \
	--genomeDir ${ref_dir}/star_index \
	--runThreadN 4 \
	--limitBAMsortRAM 1239463334 \
	--readFilesCommand zcat \
	--quantMode GeneCounts \
	--readFilesIn ${R1},${R2} \
	--outFileNamePrefix ${out_dir}/${sid}_ \
	--outReadsUnmapped Fastx \
	--outSAMtype BAM SortedByCoordinate \
	--outSAMunmapped Within \
	--outSAMattributes Standard
done

# DGE_TAB
if [[ -d "3_dge_analysis/" ]]
then
	rm -rf 3_dge_analysis/
fi

mkdir 3_dge_analysis
mkdir 3_dge_analysis/reads_per_gene_tabs

for sid in $(cat sample_ids.txt)
do 
	cp 2_STAR_mapping/${sid}/${sid}_ReadsPerGene.out.tab 3_dge_analysis/reads_per_gene_tabs/.
done

#cd 3_dge_analysis
#python3 ../merg_star_tabs.py */*_ReadsPerGene.out.tab

# DGE_analysis
#cp ../coldata.tsv .
#cp ../deseq2_analysis.R .

#Rscript deseq2_analysis.R
       	
