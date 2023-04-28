#!/bin/bash
#SBATCH -n 1
#SBATCH --array=1-1000
#SBATCH -J job

##############################################################################################################
INPUT="<Fill the path to the output directory of 06.get.random.snp.sh.>"
OUTPUT="<Output directory>"
LD_REF="<Fill the path to the output directory of 01.prep.sh.>"
##############################################################################################################

p=${SLURM_ARRAY_TASK_ID}
cd    $INPUT
mkdir $OUTPUT/$p
tmpln=`wc -l $p | awk '{print $1}'`

for i in `seq 1 $tmpln`
do
CHR=`sed -n "$i"p $p | gawk '{print $1}'`
ID=`sed -n  "$i"p $p | gawk '{print $2}'`
plink --silent --bfile $LD_REF/chr$CHR --ld-snp $ID  --ld-window 99999 --ld-window-kb 500 --out $OUTPUT/$p/$i --r2
done 
