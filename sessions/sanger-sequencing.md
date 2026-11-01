# Session 3: Sanger Sequencing Analysis

**Olabode Omotoso**
olabodeomotoso@gmail.com
November 1, 2026

*Prepared for the Nigerian Liver Cancer Molecular Research Group*

**Tools:** FinchTV, NCBI BLAST, Expasy Translate

## Learning objectives

By the end of this session you should be able to:

- Explain briefly how Sanger sequencing works and where it fits next to arrays and NGS.
- Open and read a chromatogram and judge sequence quality.
- Trim low-quality ends and resolve ambiguous bases.
- Identify your sequence with NCBI BLAST and interpret the hits.
- Translate a nucleotide sequence into protein with Expasy.

## Background

Sanger sequencing works by chain termination. Fluorescent ddNTPs stop the growing DNA strand at each base, and the fragments are separated by capillary electrophoresis. A detector reads the color of each fragment as it passes, and each color corresponds to one base. The result is a chromatogram, a trace of colored peaks that we read as a sequence.

Compared with other genetic data types, genotyping arrays measure a fixed set of SNPs, NGS reads many regions at scale, and Sanger reads one region very accurately.

## Why Sanger sequencing is still important

**Good uses**

- Confirming a PCR product
- Validating a candidate variant
- Sequencing one gene region
- Microbial or fungal identification
- Small phylogenetic studies

**Strengths**

- Direct visual trace inspection
- Long, readable single amplicons
- Simple workflow
- Useful for validation
- Relatively low setup burden

**Limitations**

- Low throughput
- One dominant template expected
- Weak for complex mixtures
- Read quality declines at ends
- Poor quality reads sometimes at the start

## Getting the files

1. Open the repository branch: <https://github.com/OlabodeOmotoso/Liver_Cancer_Group/tree/Sanger_sequencing_analysis>
2. Download the whole branch with **Code > Download ZIP**. The web preview cannot open `.ab1` files, so do not click them on GitHub.
3. Unzip the folder.
4. The sequence files end in `.ab1`, for example:
   - `SAMPLE_1_F.ab1`
   - `SAMPLE_1_R.ab1`

## Inspecting the chromatogram in FinchTV

1. Open FinchTV and use **File > Open** to load one `.ab1` file.
2. Look at the peaks:
   - Colors: A green, C blue, G black, T red.
   - Good regions have tall, evenly spaced, single peaks.
   - The first 20 to 30 bases and the tail end are usually noisy.
3. Look for ambiguous positions. These are not always an N. A base caller reports a double peak or a weak signal using an IUPAC ambiguity code:

| Code | Bases | Meaning |
|---|---|---|
| R | A or G | Purine |
| Y | C or T | Pyrimidine |
| S | G or C | Strong interaction (3 H-bonds) |
| W | A or T | Weak interaction (2 H-bonds) |
| K | G or T | Keto |
| M | A or C | Amino |
| B | C, G or T | Not A |
| D | A, G or T | Not C |
| H | A, C or T | Not G |
| V | A, C or G | Not T |
| N | A, C, G or T | Any base, completely unknown or unreadable position |

4. Questions to answer:
   - Where does the clean region start and end?
   - How many ambiguous positions are there, and which codes do you see?
   - Is the read forward or reverse?

## Editing and base calling

1. Select the noisy start and end and trim them.
2. For each ambiguous position, look at the peaks underneath and decide the correct base. If two peaks overlap, keep the matching IUPAC code (for example R for A or G), since this may be a heterozygous site.
3. Copy the cleaned sequence and save it as a plain text or FASTA file:

```
>SAMPLE_1_F_clean
ATGC...
```

## BLAST on NCBI

1. Go to <https://blast.ncbi.nlm.nih.gov/Blast.cgi> and choose **Nucleotide BLAST**.
2. Paste your cleaned FASTA sequence.
3. For the database, start with **Standard databases (nr/nt)**. Choose **Human genomic plus transcript** if you expect a human sequence.
4. Click **BLAST** and wait for the results.
5. Read the top hit:

| Column | What it tells you |
|---|---|
| Query cover | How much of your sequence matches |
| E-value | Chance of a match this good by luck (smaller is better) |
| Percent identity | How similar the match is |
| Description | Gene or sequence it matches |

## Translating with Expasy

1. Go to <https://web.expasy.org/translate/> and paste the cleaned sequence.
2. Expasy shows **six reading frames** (three forward, three reverse).
3. Pick the frame with the long open reading frame, usually starting with **Met** and without early stop codons.
4. For a reverse read, reverse-complement it first, then translate.
5. Copy the protein sequence into your notes.

## Additional resources

- **NCBI ORFfinder:** <https://www.ncbi.nlm.nih.gov/orffinder> finds open reading frames in your sequence and is a useful second check on the frame you picked in Expasy.

## Homework

1. Repeat the full workflow on the reverse read for the same sample.
2. Compare the forward and reverse results. Do they agree?
3. Write 3 to 4 sentences: what gene did you identify, how good was the match, and what did the protein translation show?
