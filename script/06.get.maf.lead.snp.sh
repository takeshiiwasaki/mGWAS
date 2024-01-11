#!/bin/bash

INPUT="<Please fill in the path to input file, in which the first column represents the chromosome, and the second column represents SNPID>"
INPUT="../data/04_get_ld.txt"

ln=`wc -l $INPUT | awk '{print $1}'`
for i in `seq 1 $ln`
do
CHR=`sed -n "$i"p $INPUT | cut -f 1`
ID=`sed -n "$i"p  $INPUT | cut -f 2`
plink --bfile ~/GCMS/permutation.spline3/1K/chr$CHR --snp $ID --freq --silent
sed -n 2p plink.frq  | awk '{print '$CHR'"\t"$5}'
rm plink.nosex plink.frq plink.log
done > ../data/06_CHR_MAF.txt

