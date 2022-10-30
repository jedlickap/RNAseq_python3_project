import os
from glob import glob
import datetime
import argparse

def main():
        print("Started at {0}".format(datetime.now()))
        parser = argparse.ArgumentParser()
        parser.add_argument("-fq", "--fq_dir", help="Path to dir with all fastq[.gz] files")
        parser.add_argument("-s", "--sample_table", help="Path to sample table")
        parser.add_argument("-g", "--gtf", help="Path to reference annotation [in gtf or gff2 format]", default=None)
        parser.add_argument("-fa", "--fasta", help="Path to reference genome", default=None)
        parser.add_argument("-t", "--threads", help="number of multiprocessing threads for Trimmomatic and STAR", default="1")
        parser.add_argument("-o", "--output_dir", help="Path to output directory")
        parser.add_argument("-de", "--differential_expression", help="Set to True to run differential expression", default="false")
        args = parser.parse_args()
        fq_dir = args.fq_files
        sample_table = args.sample_table
        gtf = args.gtf
        fasta = args.fasta
        threads = args.threads
        output_dir = args.output_dir
        differential_exp = args.differential_expression
        
        # files check
        ## fastq files
        if glob(fq_dir+"/*.*"):
            for f in glob(fq_dir+"/*.*"):
                if os.path.getsize(f) > 0:
                    print('Fastq files seems to be OK.')
                    break
                else:
                    return print(f'File {f} exists, but seems to be empty.')
        else:
            return print(f'Fastq files folder is empty.')
        
        ## 
if __name__ == '__main__':
    main()