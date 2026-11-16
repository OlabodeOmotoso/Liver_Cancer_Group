dir.create("results",showWarnings=FALSE)
ff <- list.files("results",pattern="12_adjusted.*glm.logistic",full.names=TRUE)
if(length(ff)==0) stop("Adjusted PLINK2 logistic result not found")
d <- read.table(ff[1],header=TRUE,check.names=FALSE)
if("TEST" %in% names(d)) d <- d[d$TEST=="ADD",]
d <- d[is.finite(d$P) & d$P>0,]
chrcol <- if ("#CHROM" %in% names(d)) "#CHROM" else if ("CHROM" %in% names(d)) "CHROM" else stop("Chromosome column not found")
d <- d[order(as.numeric(d[[chrcol]]),d$POS),]; d$idx<-seq_len(nrow(d)); d$mlogp <- -log10(d$P)
png("results/13_manhattan.png",1400,700,res=150)
plot(d$idx,d$mlogp,col=ifelse(as.numeric(d[[chrcol]])%%2,"#0B6E75","#E7B34A"),pch=20,cex=.55,xlab="Marker order",ylab="-log10(P)",main="Synthetic liver cancer GWAS")
abline(h=-log10(0.05/10000),col="red",lty=2); dev.off()
png("results/13_qq.png",800,800,res=150); o<-sort(d$P); e<-ppoints(length(o)); plot(-log10(e),-log10(o),pch=20,cex=.6,xlab="Expected -log10(P)",ylab="Observed -log10(P)",main="Q-Q plot"); abline(0,1,col="red"); dev.off()
