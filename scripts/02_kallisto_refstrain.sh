#!/usr/bin/bash -l
#SBATCH -c 24 --mem 65gb -p short --out logs/run_kallisto_refstrain.log
CPU=24
module load pixi
for a in $(ls refstrain_index/*.idx)
do
	m=$(basename $a .idx)
	echo "$m"
	[ -f refstrain_results/kallisto_quant_${m}/run_info.json ] || pixi run kallisto quant -t $CPU -i $a --bootstrap-samples=100 -o refstrain_results/kallisto_quant_${m} --pseudobam reads/*.gz
done
