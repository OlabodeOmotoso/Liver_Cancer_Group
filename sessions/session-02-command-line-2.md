---
title: "Session 2: Command Line II"
nav_order: 3
---

# Session 2: Command Line II

**Olabode Omotoso**<br>
olabodeomotoso@gmail.com<br>
October 18, 2026

*Prepared for the Nigerian Liver Cancer Molecular Research Group*

This is the last session on Linux.

## Recap

- `history`
- `clear`
- `man`
- `ls` (`-lha`)
- `pwd`
- `cd` (`~`, `../..`, `..`)
- `mkdir`
- `chmod`
- `chmod` (drwx, ugo, 777, 421)

## Think in pipelines

- `cat`: read
- `grep`: filter rows
- `cut`: select columns
- `sort`: arrange
- `uniq -c`: count
- `>`: save

```
cat sample_panel.tsv | grep AFR | cut -f2 | sort | uniq -c > population_counts.txt
```

## Hands-on session

### Get the files

Use `wget` or `curl -O` to download each file.

```
wget https://raw.githubusercontent.com/OlabodeOmotoso/Liver_Cancer_Group/refs/heads/main/Nigeria_Simulated_Liver_Cancer_Dataset.csv
```

```
curl -O https://github.com/OlabodeOmotoso/Liver_Cancer_Group/raw/refs/heads/main/Nigeria_Simulated_Liver_Cancer_Training_Dataset.xlsx
```

```
wget https://raw.githubusercontent.com/OlabodeOmotoso/Liver_Cancer_Group/refs/heads/main/shell_script.sh
```

### Viewing files

`cat`, `head`, `tail`, `less`, `wc -l`

### Search patterns

```
grep "Case" Nigeria_Simulated_Liver_Cancer_Dataset.csv
```

### Pipes

```
cat Nigeria_Simulated_Liver_Cancer_Dataset.csv | head
```

### Redirection

| Symbol | Meaning | Example |
|---|---|---|
| `>` | Overwrite output | `head data.csv > preview.txt` |
| `>>` | Append output | `head data.csv >> preview.txt` |
