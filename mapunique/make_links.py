#!/usr/bin/env python3
import os
from pathlib import Path

refstrain_dir = Path("../refstrain_results")
current_dir = Path(".")

for folder in sorted(refstrain_dir.iterdir()):
    if folder.is_dir() and folder.name.startswith("kallisto_quant_"):
        sample_name = folder.name.replace("kallisto_quant_", "")
        abundances_file = folder / "abundance.tsv"
        
        if abundances_file.exists():
            target_dir = current_dir / sample_name
            target_dir.mkdir(exist_ok=True)
            symlink_path = target_dir / "abundance.tsv"
            symlink_path.unlink(missing_ok=True)
            symlink_path.symlink_to(os.path.relpath(abundances_file, target_dir))
            print(f"Created: {symlink_path} -> {abundances_file}")
        else:
            print(f"Warning: {abundances_file} not found")
