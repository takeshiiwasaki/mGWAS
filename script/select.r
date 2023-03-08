# Fix bug in 03_select_LeadSNPs.r for very small P values

# library(qqman)
library(data.table)

margin = 500000

################## Function ##################
selectLeadSNPs <- function(x)
# Assuming x as a gwas result from a single chromosome
{
  #sigs <- subset(x, P < 5e-8)
  sigs <- subset(x, logp > -log10(5e-8/121))
  if (nrow(sigs) == 0) return(NULL)

  sigs1 <- sigs[order(sigs$POS),]
  leadSNP = NULL

  start = 0
  stop = 0
  for (i in 1:nrow(sigs1))
  {
    if (start == 0)
    {
      start = sigs1$POS[i]
    }
    else if (sigs1$POS[i] - stop > margin)
    {
      sigtmp <- subset(x, POS > start - margin & POS < stop + margin)
      #leadSNP <- append(leadSNP,sigtmp[which.min(sigtmp$P),]$ID)
      leadSNP <- append(leadSNP,sigtmp[which.max(sigtmp$logp),]$POS)
      start = sigs1$POS[i]
    }
    stop = sigs1$POS[i]
  }
  sigtmp <- subset(x, POS > start - margin & POS < stop + margin)
  #leadSNP <- append(leadSNP,sigtmp[which.min(sigtmp$P),]$ID)
  leadSNP <- append(leadSNP,sigtmp[which.max(sigtmp$logp),]$POS)

  return(leadSNP)
}

args = commandArgs(trailingOnly=TRUE)

mListFile = args[1]
prefix = args[2]
postfix = args[3]
outFile = args[4]

gwas_dat <- NULL

ms <- read.table(mListFile, F)

# Data integration
assocSNPs <- NULL
for(m in ms$V1){
  for (chrom in 1:23)
  {
    tmp_dat <- fread(paste(prefix,".",chrom,".",m,".",postfix,sep=""))
    tmp_dat_reduced <- subset(tmp_dat, logp > -log10(1e-5))
    #tmp_dat_reduced <- subset(tmp_dat, P < 1e-5)
    tmp_dat_reduced$m <- c(m)
    # gwas_dat <- rbind(gwas_dat, tmp_dat_reduced)

    leadSNPs <- selectLeadSNPs(tmp_dat_reduced)
    tmp_dat_reduced$type <- ifelse(tmp_dat_reduced$logp > -log10(5e-8/121),"significant","suggestive")
    #tmp_dat_reduced$type <- ifelse(tmp_dat_reduced$P < 5e-8,"significant","suggestive")
    tmp_dat_reduced$type[tmp_dat_reduced$POS %in% leadSNPs] <- c("lead")

    assocSNPs <- rbind(assocSNPs, tmp_dat_reduced)
  }
}

write.table(assocSNPs, outFile, col.name=T, row.name=F, quote=F, sep="\t")

# options(width=500)
# print(leadSNPs)

# png(out,height=600,width=800)
# manhattan(gwas_dat, chr = "CHROM", bp = "POS", p = "P", snp = "ID", highlight = highlights, main = title)
# dev.off()
