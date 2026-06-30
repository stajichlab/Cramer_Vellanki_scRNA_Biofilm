#!/usr/bin/bash -l
#SBATCH -p short -c 2 --mem 16gb  --out logs/build_index2.log
module load pixi
mkdir -p refstrain_index

for file in $(ls refstrain_db/*.fa)
do
	base=$(basename $file .mrna-transcripts.fa)
	[ -f refstrain_index/${base}.idx ] || pixi run kallisto index -i refstrain_index/${base}.idx $file
done
