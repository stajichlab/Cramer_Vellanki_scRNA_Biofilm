#!/usr/bin/bash -l
#SBATCH -c 24 --mem 65gb -p short --out logs/run_kallisto.log
CPU=24
module load pixi
for a in $(ls index/*.idx)
do
	m=$(basename $a .idx)
	echo "$m, $CPU"
	[ -f results/kallisto_quant_${m}/run_info.json ] || pixi run kallisto quant -t $CPU -i $a --bootstrap-samples=100 -o results/kallisto_quant_${m} --pseudobam reads/*.gz
done
