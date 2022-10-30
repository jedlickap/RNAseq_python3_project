### Input
raw reads(fq.gz/fastq) | reference fasta | gff/gft annotation | col_samples.tab

### Pipeline
- trimming
- sampling
	1. get number of reads from all samples
	2. round the lowest number of reads to thousends level (e.g. 2555580 -> 2555000)
	3. sample all samples to this read counts 
		`seqtk sample -s100 ${fq1} 2555000 | gzip > ${pref}_1_subsampled.fq.gz`
		
- indexing genomic fasta
- mapping
	1. STAR
	2. SALMON
	3. ???

### Scripts
main.py
	cmd arguments
		paths to:
			1. reference fasta
			2. reference gff/gtf
			3. fastq reads files in format `samplenameXY_[12].fastq.gz`
			
	main():
		run classes and methods based on arguments

classes.py
	dependency_check 
		soft: trimmomatic, STAR, R - and deseq needed libraries
		inputs: raw reads(fq.gz/fastq) | reference fasta | gff/gft annotation | col_samples.tab		
	RNAseq_PE
		index
		mapping
		filter tab from STAR output
		
folder_bash_scripts
	trimmomatic_pe.sh
	star_pe.sh
	
folder_R_scripts
	run_deseq
	
