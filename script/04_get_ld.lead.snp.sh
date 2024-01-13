#!/bin/bash

INPUT="data/04_get_ld.txt"    #Please fill in the path to input file, in which the first column represents the chromosome, and the second column represents SNPID
OUTPUT="04_get_ld_lead_snp"   #Please fill in the path to onput directory
LD_REF="function_of_variant"  #Please fill in the path to the directory of 1KG reference.

mkdir $OUTPUT
ln=`wc -l $INPUT | awk '{print $1}'`
for i in `seq 1 $ln`
do
CHR=`sed -n "$i"p $INPUT  | gawk '{print $1}'`
ID=`sed -n "$i"p  $OUTPUT | gawk '{print $4}'`
output=`expr $i - 1`
plink --bfile $LD_REF/chr$CHR --ld-snp $ID  --ld-window 99999 --ld-window-kb 500 --out $OUTPUT/$output --r2
done

