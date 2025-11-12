#!/usr/bin/python
"""
This is my first Python program.
It computes the GC content of a DNA sequence.
"""

# Get DNA sequence
dna = "AGCTATAG"

# Count C's in DNA sequence
no_c = dna.count('C')

# Count G's in DNA sequence
no_g = dna.count('G')

# Get length of DNA sequence
dna_length = len(dna)

# Compute GC percentage
gc_percent = ((no_c + no_g) * 100) / dna_length

# Print GC percentage
print(gc_percent)
