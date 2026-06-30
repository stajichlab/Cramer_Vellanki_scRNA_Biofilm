#!/usr/bin/bash -l
#SBATCH -p short -c 2 --mem 16gb  --out logs/build_index.log
module load pixi
mkdir -p index

for file in $(ls db/*.fasta db/*.fa)
do
	base=$(basename $file .fasta)
	base=$(basename $base .mrna-transcripts.fa)
	[ -f index/${base}.idx ] || pixi run kallisto index -i index/${base}.idx $file
done
