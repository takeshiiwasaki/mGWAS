#!/bin/bash
#SBATCH -n 1
#SBATCH --array=1-1000
#SBATCH -p NGS789
#SBATCH -J ctl
#SBATCH -o  /home/tiwasaki/GCMS/permutation.median.PC10/03script/output.txt

export PATH=/home/tiwasaki/src:$PATH

p=$(seq 1 1000 | sed -n ${SLURM_ARRAY_TASK_ID}p)

mkdir /home/tiwasaki/GCMS/permutation.median.PC10/01data/control.dist.ld/$p
cd    /home/tiwasaki/GCMS/permutation.median.PC10/01data/control.dist

tmpln=`wc -l /home/tiwasaki/GCMS/permutation.median.PC10/01data/case/chr.maf.lead.snp | awk '{print $1}'`
for i in `seq 1 $tmpln`
do
CHR=`sed -n "$i"p $p | gawk '{print $1}'`
ID=`sed -n  "$i"p $p | gawk '{print $2}'`
plink --silent --bfile /home/tiwasaki/GCMS/permutation.qtl/1K/chr$CHR --ld-snp $ID  --ld-window 99999 --ld-window-kb 500 --out /home/tiwasaki/GCMS/permutation.median.PC10/01data/control.dist.ld/$p/$i --r2
done 
