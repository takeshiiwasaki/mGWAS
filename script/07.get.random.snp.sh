#!/bin/bash
##############################################################################################################
INPUT="data/06_CHR_MAF.txt"            #Please fill in the path to the output file of 06.get.random.snp.sh.
OUTPUT="07_get_random_snp"             #Please fill in the path to output directory
TMP_OUTPUT1="07_get_random_snp_tmp1"   #Please fill in the path to temporal output directory   
TMP_OUTPUT2="07_get_random_snp_tmp2"   #Please fill in the path to temporal output directory
MAF_REF="function_of_variant"          #Fill the path to the output directory of 01.prep.sh.
N_PERM=1000
##############################################################################################################

#Select chromosome and MAF- matched SNPs
mkdir  $TMP_OUTPUT1
cd     $TMP_OUTPUT1
linenumber=`wc -l $INPUT | gawk '{print $1}'`
for i in `seq 1 $linenumber`
do
CHR=`sed -n "$i"p $INPUT   | gawk '{print $1}'`
lower=`sed -n "$i"p $INPUT | gawk '{print $2-0.025}'`
upper=`sed -n "$i"p $INPUT | gawk '{print $2+0.025}'`
awk '$5 > '$lower' && $5  < '$upper' {print $1"\t"$2}' $MAF_REF/chr$CHR.frq > $i
done

##Randomly select SNPs (n=N_perm)
mkdir  $TMP_OUTPUT2
for i in *
do
linenumber=`wc -l $i | awk '{print $1}'`
if [ $linenumber -gt $N_PERM ]; then
        shuf -n $N_PERM $i > $TMP_OUTPUT2/$i
else
        echo "Target number of SNP might be small.. for "'$i'""
	cycle=`echo $(($N_PERM/$linenumber+1))`
        cut=`echo $(($N_PERM+1))`
        for c in `seq 1 $cycle`
        do
        shuf $i
        done | sed ''$cut',$d' > $TMP_OUTPUT2/$i
fi
done
mkdir $OUTPUT
cd    $OUTPUT
for i in `seq 1 1000`
do
ls | sort -n | while read k
do
sed -n "$i"p $k 
done > $OUTPUT/$i
done

rm -rf $TMP_OUTPUT1 $TMP_OUTPUT2
