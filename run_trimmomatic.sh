#! /bin/bash
# run as:
# bash run_trimmomatic.sh 2>&1 | tee trimmomatic_run.log

for dir in $(cat fq_dirs.txt)
do
        cd ${dir}
                pref=$(echo ${dir}|sed 's/\///g')
                fq1=$pref'_1.fq.gz'
                fq2=$pref'_2.fq.gz'
                out_fq1=${fq1%fq.gz}
                out_fq2=${fq2%fq.gz}
                d=$pref'_trimmed'
                mkdir $d
                mv $fq1 $d'/.'
                mv $fq2 $d'/.'
                cd $d
                        TrimmomaticPE -threads 6 $fq1 $fq2 $out_fq1'_paired.fq.gz' $out_fq1'_unpaired.fq.gz' $out_fq2'_paired.fq.gz' $out_fq2'_unpaired.fq.gz' ILLUMINACLIP:TruSeq3-PE.fa:2:30:10 HEADCROP:15 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:50
                cd ../
        cd ..
done
