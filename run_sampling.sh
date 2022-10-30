#! /bin/bash

for fq1 in $(ls P*_1_paired.fq.gz)
do
	fq2=$(echo ${fq1}|sed 's/_1_/_2_/g')
	pref=$(echo ${fq1}|cut -f 1 -d "_")
	echo `seqtk sample -s100 ${fq1} 11500000 | gzip > ${pref}_1_subsampled.fq.gz`
	echo `seqtk sample -s100 ${fq2} 11500000 | gzip > ${pref}_2_subsampled.fq.gz`
done
