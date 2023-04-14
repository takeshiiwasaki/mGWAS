#!/bin/bash
#$1 "chr	MAF" file
#2  permutation number

mkdir  /home/tiwasaki/GCMS/permutation.median.PC10/01data/case.same.chr.maf.list
cd     /home/tiwasaki/GCMS/permutation.median.PC10/01data/case.same.chr.maf.list

linenumber=`wc -l $1 | gawk '{print $1}'`

for i in `seq 1 $linenumber`
do
CHR=`sed -n "$i"p $1 | gawk '{print $1}'`
lower=`sed -n "$i"p $1 | gawk '{print $2-0.025}'`
upper=`sed -n "$i"p $1 | gawk '{print $2+0.025}'`
awk '$5 > '$lower' && $5  < '$upper' {print $1"\t"$2}' /home/tiwasaki/GCMS/permutation.qtl/1K/chr$CHR.frq > $i
done

mkdir /home/tiwasaki/GCMS/permutation.median.PC10/01data/case.same.chr.maf.random

for i in *
do
linenumber=`wc -l $i | awk '{print $1}'`
if [ $linenumber -gt $2 ]; then
        shuf -n $2 $i > /home/tiwasaki/GCMS/permutation.median.PC10/01data/case.same.chr.maf.random/$i
else
        echo "Target number of SNP might be small.. for "'$i'""
	cycle=`echo $(($2/$linenumber+1))`
        cut=`echo $(($2+1))`
        for c in `seq 1 $cycle`
        do
        shuf $i
        done | sed ''$cut',$d' > /home/tiwasaki/GCMS/permutation.median.PC10/01data/case.same.chr.maf.random/$i
fi
done

cd /home/tiwasaki/GCMS/permutation.median.PC10/01data/case.same.chr.maf.random

for i in `seq 1 1000`
do
ls | sort -n | while read k
do
sed -n "$i"p $k 
done > /home/tiwasaki/GCMS/permutation.median.PC10/01data/control/$i
done
