# Session 7: Genotype data formats and PLINK quality control

**Olabode Omotoso** olabodeomotoso@gmail.com
for: The Nigerian Liver Cancer Molecular Research Group

## Training dataset

This session uses a fully simulated liver cancer genotype dataset. The genotype calls, marker identifiers, genomic positions, quality-control problems, relatedness patterns, genotype structure, and association signals are synthetic. The files are for training only and must not be interpreted as evidence about Nigerian populations or liver cancer genetics.

### Learning objectives

By the end of this session, participants should be able to:

1. Explain the roles of PLINK BED, BIM, and FAM files.
2. Inspect PLINK files in an Ubuntu terminal.
3. Calculate sample and marker missingness.
4. apply sample missingness, SNP missingness, MAF, and HWE filters.
5. Perform a genotype-based sex check using chromosome-X markers.
6. Explore relatedness using LD-pruned markers.
7. Run PCA and interpret synthetic genotype structure cautiously.
8. Run unadjusted and adjusted logistic association analyses.
9. Create PCA, Manhattan, and Q-Q plots in R.

## Computing environment

All commands are written for **Ubuntu running in WSL**. Open the repository in **Visual Studio Code connected to WSL**, then run commands in the VS Code Ubuntu terminal.

Do not run the commands in Windows PowerShell or Command Prompt.

## Part A: One-time installation before class

Open **Ubuntu** from the Windows Start menu.

```bash
cd ~
git clone https://github.com/OlabodeOmotoso/Liver_Cancer_Group.git
cd Liver_Cancer_Group/Session_7
chmod +x setup_wsl.sh check_setup.sh
./setup_wsl.sh
```

The script installs:

- Git
- R and `Rscript`
- PLINK 1.9
- PLINK 2.0
- `wget`, `curl`, and `unzip`

When installation finishes, close the Ubuntu terminal and open it again.

Return to the session folder and verify the installation:

```bash
cd ~/Liver_Cancer_Group/Session_7
./check_setup.sh
```

The last line should be:

```text
READY FOR SESSION 7
```

## Part B: Open the folder in Visual Studio Code

From the Ubuntu terminal:

```bash
cd ~/Liver_Cancer_Group/Session_7
code .
```

If Visual Studio Code asks to install the **WSL extension**, install it and select **Reopen Folder in WSL**.

In Visual Studio Code, open **Terminal > New Terminal**. The terminal prompt should show a Linux path such as:

```text
/home/username/Liver_Cancer_Group/Session_7
```

It should not show a Windows path beginning with `C:\`.

## Part C: Start a clean results folder

```bash
pwd
ls -lh
ls -lh data
mkdir -p results
```

## Step 1: Inspect BED, BIM, and FAM

```bash
ls -lh data/Nigeria_HCC_training_raw.*
head -n 5 data/Nigeria_HCC_training_raw.fam
head -n 5 data/Nigeria_HCC_training_raw.bim
wc -l data/Nigeria_HCC_training_raw.fam data/Nigeria_HCC_training_raw.bim
```

The FAM fields are:

```text
FID IID Father Mother Sex Phenotype
```

Sex coding:

```text
1 = male
2 = female
0 = unknown
```

Phenotype coding:

```text
1 = control
2 = case
-9 = missing
```

Confirm that PLINK can read the files:

```bash
plink \
  --bfile data/Nigeria_HCC_training_raw \
  --freq \
  --out results/01_read_check
```

Inspect the output:

```bash
cat results/01_read_check.log
head results/01_read_check.frq
```

## Step 2: Calculate baseline missingness

Do not filter yet.

```bash
plink \
  --bfile data/Nigeria_HCC_training_raw \
  --missing \
  --out results/02_missing_raw
```

Inspect sample missingness:

```bash
head results/02_missing_raw.imiss
sort -k6,6nr results/02_missing_raw.imiss | head
```

Inspect marker missingness:

```bash
head results/02_missing_raw.lmiss
sort -k5,5nr results/02_missing_raw.lmiss | head
```

- `--mind` filters people using sample missingness.
- `--geno` filters markers using SNP missingness.

## Step 3: Remove samples with more than 10% missing genotypes

```bash
plink \
  --bfile data/Nigeria_HCC_training_raw \
  --mind 0.10 \
  --make-bed \
  --out results/03_mind10
```

Inspect the log and retained sample count:

```bash
tail -n 20 results/03_mind10.log
wc -l results/03_mind10.fam
```

## Step 4: Examine and filter minor allele frequency

```bash
plink \
  --bfile results/03_mind10 \
  --freq \
  --out results/04_freq
```

```bash
head results/04_freq.frq
```

Keep markers with MAF of at least 5%:

```bash
plink \
  --bfile results/03_mind10 \
  --maf 0.05 \
  --make-bed \
  --out results/04_maf05
```

Compare counts:

```bash
wc -l results/03_mind10.bim results/04_maf05.bim
```

## Step 5: Filter marker and sample missingness

```bash
plink \
  --bfile results/04_maf05 \
  --geno 0.05 \
  --make-bed \
  --out results/05_geno05
```

```bash
plink \
  --bfile results/05_geno05 \
  --mind 0.03 \
  --make-bed \
  --out results/05_mind03
```

Recalculate missingness:

```bash
plink \
  --bfile results/05_mind03 \
  --missing \
  --out results/05_missing_after
```

## Step 6: Genotype-based sex check

The training dataset contains 400 synthetic chromosome-X markers.

```bash
plink \
  --bfile results/05_mind03 \
  --check-sex \
  --out results/06_sexcheck
```

Inspect the report:

```bash
head results/06_sexcheck.sexcheck
awk '$5=="PROBLEM" {print}' results/06_sexcheck.sexcheck
```

A discrepancy is a finding to investigate. Do not automatically change or remove a participant.

## Step 7: LD pruning and relatedness

```bash
plink \
  --bfile results/05_mind03 \
  --chr 1-22 \
  --indep-pairwise 50 5 0.2 \
  --out results/07_prune
```

```bash
plink \
  --bfile results/05_mind03 \
  --chr 1-22 \
  --extract results/07_prune.prune.in \
  --genome \
  --out results/07_relatedness
```

Inspect high PI_HAT pairs:

```bash
awk 'NR==1 || $10>0.40' results/07_relatedness.genome | head -n 20
```

## Step 8: Hardy-Weinberg equilibrium in controls

```bash
plink \
  --bfile results/05_mind03 \
  --hardy \
  --out results/08_hwe_report
```

Inspect unaffected/control rows:

```bash
awk 'NR==1 || $3=="UNAFF"' results/08_hwe_report.hwe | head
```

Apply the illustrative threshold:

```bash
plink \
  --bfile results/05_mind03 \
  --hwe 1e-6 \
  --make-bed \
  --out results/08_hwe_filtered
```

## Step 9: PCA using LD-pruned autosomal markers

```bash
plink2 \
  --bfile results/08_hwe_filtered \
  --chr 1-22 \
  --indep-pairwise 50 5 0.2 \
  --out results/09_prune
```

```bash
plink2 \
  --bfile results/08_hwe_filtered \
  --chr 1-22 \
  --extract results/09_prune.prune.in \
  --pca 10 approx \
  --out results/09_pca
```

Create the PCA figure:

```bash
Rscript scripts/Student_plot_pca.R
```

The labels `Synthetic_A`, `Synthetic_B`, and `Synthetic_C` are anonymous training groups. They do not represent Nigerian states, ethnicities, geopolitical zones, or validated ancestry groups.

## Step 10: Unadjusted logistic association analysis

```bash
plink2 \
  --bfile results/08_hwe_filtered \
  --chr 1-22 \
  --glm hide-covar allow-no-covars \
  --out results/10_unadjusted
```

```bash
ls -lh results/10_unadjusted*
```

## Step 11: Combine covariates with principal components

```bash
Rscript scripts/Student_make_covariates.R
```

```bash
head results/11_covariates_with_pcs.tsv
```

## Step 12: Adjusted logistic association analysis

```bash
plink2 \
  --bfile results/08_hwe_filtered \
  --chr 1-22 \
  --covar results/11_covariates_with_pcs.tsv \
  --covar-name Age_years,Sex_code,HBV_positive,HCV_positive,BMI_kg_m2,PC1,PC2,PC3,PC4,PC5 \
  --glm hide-covar \
  --out results/12_adjusted
```

## Step 13: Create Manhattan and Q-Q plots

```bash
Rscript scripts/Student_plot_gwas.R
```

```bash
ls -lh results/13_*.png
```

At 10,000 tests, the teaching Bonferroni threshold is:

```text
0.05 / 10,000 = 5 × 10^-6
```

The association signals are planted training signals and are not liver cancer discoveries.

## Troubleshooting

### `plink: command not found`

Run:

```bash
source ~/.bashrc
which plink
plink --version
```

If it remains missing:

```bash
./setup_wsl.sh
```

### `plink2: command not found`

```bash
sudo apt update
sudo apt install -y plink2
plink2 --version
```

### `Rscript: command not found`

```bash
sudo apt update
sudo apt install -y r-base
Rscript --version
```

### File not found

Confirm the current directory:

```bash
pwd
ls -lh
ls -lh data
```

The correct directory ends with:

```text
Liver_Cancer_Group/Session_7
```

### Visual Studio Code terminal shows a Windows path

Select the green/blue remote indicator in the lower-left corner of Visual Studio Code and choose:

```text
Reopen Folder in WSL
```

Then open a new terminal.

### Start the practical again

```bash
cd ~/Liver_Cancer_Group/Session_7
rm -rf results
mkdir results
```
