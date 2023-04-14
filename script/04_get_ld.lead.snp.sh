#!/bin/bash
#$1= lead snp

ln=`wc -l ~/GCMS/condition.median.PC10/all.list | awk '{print $1}'`

for i in `seq 2 $ln`
do
CHR=`sed -n "$i"p ~/GCMS/condition.median.PC10/all.list | gawk '{print $1}'`
ID=`sed -n "$i"p  ~/GCMS/condition.median.PC10/all.list | gawk '{print $4}'`
output=`expr $i - 1`
plink --bfile ~/GCMS/permutation.spline3/1K/chr$CHR --ld-snp $ID  --ld-window 99999 --ld-window-kb 500 --out ~/GCMS/permutation.median.PC10/01data/case.ld/$output --r2
done

