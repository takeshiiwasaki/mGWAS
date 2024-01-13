library(data.table)
x3 <- fread("data/01_metabolite_data_corrected.xls")
library(readxl)
#clin <- read_excel("data/agesex.xlsx")
clin <- read.table("data/agesex.xls",header=1)
y3 <- merge(x3,clin,by.y="ID",by.x="ID")
colnames(y3) <- chartr("-() , ","______",colnames(y3))


Qnormalize <- function(z,age,sex)
{
  b <- rep(NA,length(z))
  nonNA <-  !is.na(z) & z!="Inf"
  if (length(which(nonNA))/length(z) < 0.5) return(b)
  print(length(nonNA))
  a <- lm(z[nonNA] ~  age[nonNA] + sex[nonNA])$residuals
  b[nonNA] <- a
  y <- qnorm((rank(b,na.last="keep")-0.5) /length(b))
  return(y)
}

getQnormDf <- function(r, outF)
{
  end=length(colnames(y3))-length(colnames(clin))+1
  print(end)
  mpos <- 3:end
  r.1 <- data.frame(FID=r$ID,IID=r$ID)
  r.1 <- cbind(r.1,r[,..mpos])
  r.1[,3:ncol(r.1)] <- apply(r.1[,3:ncol(r.1)],2,function(x) Qnormalize(x,r$age,r$sex))
  write.table(r.1, outF,col.names = T,row.names = F,quote = F,sep = "\t")
}

getQnormDf(y3,"data/02_metabolite_data_normalized.xls")
