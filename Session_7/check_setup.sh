#!/usr/bin/env bash
set -u
FAIL=0
for TOOL in git Rscript plink plink2; do
  if command -v "$TOOL" >/dev/null 2>&1; then
    echo "[OK] $TOOL: $(command -v "$TOOL")"
  else
    echo "[MISSING] $TOOL"
    FAIL=1
  fi
done
for FILE in data/Nigeria_HCC_training_raw.bed data/Nigeria_HCC_training_raw.bim data/Nigeria_HCC_training_raw.fam data/Nigeria_HCC_covariates.tsv; do
  if [ -f "$FILE" ]; then echo "[OK] $FILE"; else echo "[MISSING] $FILE"; FAIL=1; fi
done
if [ "$FAIL" -eq 0 ]; then
  echo "READY FOR SESSION 7"
else
  echo "NOT READY: fix the missing items above."
  exit 1
fi
