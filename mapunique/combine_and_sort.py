#!/usr/bin/env python3
"""Combine unmapped features with kallisto abundance and sort by TPM."""

import argparse
import sys


def main():
    parser = argparse.ArgumentParser(
        description="Filter abundances to unmapped features and sort by TPM."
    )
    parser.add_argument(
        "-u",
        "--unmapped",
        default="unmapped_features.txt",
        help="Text file with one feature ID per line",
    )
    parser.add_argument(
        "-a",
        "--abundances",
        default="abundances.tsv",
        help="Kallisto abundances TSV",
    )
    parser.add_argument(
        "-o",
        "--output",
        default="abundances_unmapped_sorted.tsv",
        help="Output file name",
    )
    args = parser.parse_args()

    genes = set()
    with open(args.unmapped) as f:
        for line in f:
            line = line.strip()
            if line:
                genes.add(line)

    rows = []
    with open(args.abundances) as f:
        header = f.readline().strip().split("\t")
        for line in f:
            fields = line.strip().split("\t")
            if not fields:
                continue
            gene_id = fields[0].rsplit("-T", 1)[0]
            if gene_id in genes:
                rows.append(fields)

    rows.sort(key=lambda x: float(x[4]), reverse=True)

    with open(args.output, "w") as f:
        f.write("\t".join(header) + "\n")
        for row in rows:
            f.write("\t".join(row) + "\n")

    print(f"Wrote {len(rows)} rows to {args.output}")


if __name__ == "__main__":
    main()
