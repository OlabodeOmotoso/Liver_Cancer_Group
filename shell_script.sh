#!/bin/bash

FILE="Nigeria_Simulated_Liver_Cancer_Dataset.csv"

echo "===== DATASET SUMMARY ====="

# Total records
echo "Total participants:"
echo $(( $(wc -l < "$FILE") - 1 ))

# Cases vs Controls
echo
echo "Liver cancer status:"
cut -d, -f18 "$FILE" | tail -n +2 | sort | uniq -c

# Sex distribution
echo
echo "Sex distribution:"
cut -d, -f6 "$FILE" | tail -n +2 | sort | uniq -c

# HBV status
echo
echo "HBV status:"
cut -d, -f12 "$FILE" | tail -n +2 | sort | uniq -c

# Average age
echo
echo "Average age:"
awk -F, 'NR>1 {sum+=$5; n++} END {print sum/n}' "$FILE"

# Top 10 states
echo
echo "Participants by State:"
cut -d, -f2 "$FILE" | tail -n +2 | sort | uniq -c | sort -nr | head
