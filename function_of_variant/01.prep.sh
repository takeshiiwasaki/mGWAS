#!/bin/bash

export PATH=$PATH:~/src/annovar
export PATH=$PATH:~/src/vcftools/src/cpp

for i in `seq 1 22` 
do
wget http://hgdownload.cse.ucsc.edu/gbdb/hg19/1000Genomes/phase3/ALL.chr"$i".phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz &
done
wait
for i in `seq 1 22`
do
mv ALL.chr"$i".phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz  $i.vcf.gz
done
wget http://hgdownload.cse.ucsc.edu/gbdb/hg19/1000Genomes/phase3/ALL.chrX.phase3_shapeit2_mvncall_integrated_v1a.20130502.genotypes.vcf.gz
(zcat ALL.chrX.phase3_shapeit2_mvncall_integrated_v1a.20130502.genotypes.vcf.gz | grep ^"#" ; zcat ALL.chrX.phase3_shapeit2_mvncall_integrated_v1a.20130502.genotypes.vcf.gz | grep -v ^"#" | awk '{print $1"\t"$2"\t"$1":"$2":"$4":"$5"\t"$0}' | cut -f 1-3,7-) |  gzip > X.vcf.gz

##Function annotate
for i in `seq 1 22` X 
do
table_annovar.pl $i.vcf.gz ~/igg4/humandb -buildver hg19 -out $i.anno.vcf -remove -protocol refGene -operation gx -nastring . -polish -xref ~/igg4/humandb/hg19_refGene.txt -vcfinput &
done
wait

sed -i '28i ##contig=<ID=X,assembly=b37,length=155270560>'                          X.anno.vcf.hg19_multianno.vcf
sed -i '28i ##FORMAT=<ID=GT,Number=1,Type=String,Description="Genotype">'           X.anno.vcf.hg19_multianno.vcf
sed -i '28i ##INFO=<ID=OLD_VARIANT,Number=1,Type=String,Description="OLD_VARIANT">' X.anno.vcf.hg19_multianno.vcf

##Regulatory information annotation
echo -e "Gm12878\nH1hesc\nHepg2\nHmec\nHsmm\nHuvec\nK562\nNhek\nNhlf" > list
for i in `seq 1 22` X
do
cat list | while read line
do
bcftools annotate -a ~/GCMS/array/encode/wgEncodeBroadHmm"$line"HMM.bed.gz -c CHROM,FROM,TO,"$line"  -h <(echo '##INFO=<ID='$line',Number=1,Type=String,Description="ENHANCER">') $i.anno.vcf.hg19_multianno.vcf > $i.anno2.vcf
mv $i.anno2.vcf $i.anno.vcf.hg19_multianno.vcf
done
done

##Extract function information for each SNP
for i in `seq 1 22` X
do
vcftools --vcf $i.anno.vcf.hg19_multianno.vcf --get-INFO Gene.refGene --get-INFO Func.refGene --get-INFO ExonicFunc.refGene --get-INFO Gm12878 --get-INFO H1hesc --get-INFO Hepg2 --get-INFO Hmec --get-INFO Hsmm --get-INFO Huvec --get-INFO K562 --get-INFO Nhek --get-INFO Nhlf --out $i &
done

wait

##Frequency information (IF you want to calculate the LD and frequency information, please specify the population to keep by '--keep' option
for i in `seq 1 22` X
do
plink --double-id --freq --make-bed --out chr"$i" --vcf $i.anno.vcf.hg19_multianno.vcf
done

for i in `seq 1 22` X
do
cut -f 2 chr$i.bim | sed '1s/^/SNP_B\n/g' > tmp
paste tmp $i.INFO  > $i.anno.tsv
done
rm tmp *.vcf.gz *.avinput *.hg19_multianno.txt *refGene.invalid_input *.INFO
