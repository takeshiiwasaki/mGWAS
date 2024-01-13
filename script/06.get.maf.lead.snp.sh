#!/bin/bash

INPUT="data/04_get_ld.txt"    #Please fill in the path to input file, in which the first column represents the chromosome, and the second column represents SNPID
LD_REF="function_of_variant"  #Please fill in the path to the directory of 1KG reference.

ln=`wc -l $INPUT | awk '{print $1}'`
for i in `seq 1 $ln`
do
CHR=`sed -n "$i"p $INPUT | cut -f 1`
ID=`sed -n "$i"p  $INPUT | cut -f 2`
plink --bfile $LD_REF/chr$CHR --snp $ID --freq --silent
sed -n 2p plink.frq  | awk '{print '$CHR'"\t"$5}'
rm plink.nosex plink.frq plink.log
done > data/06_CHR_MAF.txt

