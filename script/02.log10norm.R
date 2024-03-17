#The first argument  : Corrected metabolite data (example data: "data/01_metabolite_data_corrected.xls")
#The second argument ; Covariate file which contains unwanted features, such as age, sex (example "data/agesex.xls")
#The third argement  : Output file (example:"data/02_metabolite_data_normalized.xls")
library(data.table)
args <- commandArgs(trailingOnly = T)
x3 <- fread(args[1])
clin <- read.table(args[2],header=1)
y3 <- merge(x3,clin,by.y="ID",by.x="ID")
colnames(y3) <- chartr("-() , ","______",colnames(y3))


Qnormalize <- function(z,age,sex,pc1,pc2,pc3,pc4,pc5,pc6,pc7,pc8,pc9,pc10)
{
  b <- rep(NA,length(z))
  nonNA <-  !is.na(z) & z!="Inf"
  if (length(which(nonNA))/length(z) < 0.5) return(b)
  print(length(nonNA))
  c <-log10(z+1)
  a <- lm(c[nonNA] ~  age[nonNA]+sex[nonNA]+pc1[nonNA]+pc2[nonNA]+pc3[nonNA]+pc4[nonNA]+pc5[nonNA]+pc6[nonNA]+pc7[nonNA]+pc8[nonNA]+pc9[nonNA]+pc10[nonNA])$residuals
  b[nonNA] <- a
  y <- b
  return(y)
}

getQnormDf <- function(r, outF)
{
  end=length(colnames(y3))-length(colnames(clin))+1
  print(end)
  mpos <- 3:end
  r.1 <- data.frame(FID=r$ID,IID=r$ID)
  r.1 <- cbind(r.1,r[,..mpos])
  r.1[,3:ncol(r.1)] <- apply(r.1[,3:ncol(r.1)],2,function(x) Qnormalize(x,r$age,r$sex,r$PC1,r$PC2,r$PC3,r$PC4,r$PC5,r$PC6,r$PC7,r$PC8,r$PC9,r$PC10))
  write.table(r.1, outF,col.names = T,row.names = F,quote = F,sep = "\t")
}

getQnormDf(y3,args[3])
