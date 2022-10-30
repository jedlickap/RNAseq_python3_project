import os
import gzip
from glob import glob
from Bio import SeqIO

def fq_parse(file):
	if file.split(".")[-1] == 'gz':
		with gzip.open(file,"rt") as handle:
			for r in SeqIO.parse(handle, "fastq"):
				return r.id
	else:
		for r in SeqIO.parse(file, "fastq"):
				return r.id

def fq_check(file):
    is_exception = False
    is_fastq = False
    try:
        if fq_parse(file):
            is_fastq = True
    except:
        print(f"File \'{file}\' is not in fastq format!")
        is_exception = True
    if not is_exception and not fq_parse(file):
        print(f"File \'{file}\' is not in fastq format!")
    return is_fastq

def run_fq_check(fq_dir):
    if glob(fq_dir+"/*.*"):
        file = [i for i in glob(fq_dir+"/*.*")][0]
        if os.path.getsize(file) > 0:
            if fq_check(file):
                print('Fastq files seems to be OK.')
                return True
            else:
                return False
        else:
            print(f'File \'{file}\' exists, but seems to be empty.')                
            return False
    else:
        print(f'Fastq files folder \'{fq_dir}\'is empty.')
        return False

# # fastq_check TEST
# import sys
# f_dir = sys.argv[1]
# print(run_fq_check(f_dir))