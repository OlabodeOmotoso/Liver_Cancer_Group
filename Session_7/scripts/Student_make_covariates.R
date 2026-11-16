args <- commandArgs(trailingOnly=TRUE)
if (!dir.exists("results")) dir.create("results")
cov <- read.delim("Nigeria_HCC_covariates.tsv", check.names=FALSE)
pc <- read.table("results/09_pca.eigenvec", header=TRUE, check.names=FALSE)
if (names(pc)[1] == "#FID") names(pc)[1] <- "FID"
keep <- c("FID","IID",paste0("PC",1:5))
pc <- pc[,keep]
out <- merge(cov,pc,by=c("FID","IID"),all=FALSE,sort=FALSE)
stopifnot(nrow(out)==nrow(pc), !anyDuplicated(out$IID))
write.table(out,"results/11_covariates_with_pcs.tsv",sep="\t",quote=FALSE,row.names=FALSE,na="NA")
cat("Wrote",nrow(out),"rows to results/11_covariates_with_pcs.tsv\n")
