#!/bin/bash
#SBATCH -p short -c 4 --mem 8gb

module load liftoff

A1163_GENOME=$(realpath "../../CEA10_public/genome/FungiDB-68_AfumigatusA1163_Genome.masked.fasta")
GFF_DIR=$(realpath "../orthologs/gff")
GENOME_DIR=$(realpath "../refstrain_genomes")
TARGET_DIR="$(pwd)"

for gff in "$GFF_DIR"/*.gff3; do
    gff_name=$(basename "$gff" .gff3)
    
    # Skip A1163 reference files
    if [[ "$gff_name" == "A1163_FungiDB" || "$gff_name" == *"UCR_A1163"* ]]; then
        echo "Skipping $gff_name (reference strain)"
        continue
    fi
    
    # Check if corresponding folder exists
    if [[ -d "$TARGET_DIR/$gff_name" ]]; then
	FASTA="$GENOME_DIR/$gff_name.scaffolds.fa"
        echo "Running liftoff for $gff_name in $TARGET_DIR/$gff_name/"
        pushd "$TARGET_DIR/$gff_name"
        liftoff -o "${gff_name}_to_A1163.gff" \
            -g "$(realpath "$gff")" \
            "$A1163_GENOME" \
            $FASTA
        #cd "$TARGET_DIR"
	popd
        echo "Done: $gff_name"
    else
        echo "Skipping $gff_name - no matching folder found"
    fi
done

echo "All liftoff jobs completed"
