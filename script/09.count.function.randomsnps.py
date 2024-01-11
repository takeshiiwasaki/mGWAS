#!/bin/python

import sys
import pandas as pd
import collections
import itertools

####################################################################################################
LEAD="<Fill the path to input file of 04_get_ld.lead.snp.sh.>"
RANDOMSNP_LD="<Fill the path to the output directory of 07.get.ld.random.snp.slurm.>"
FUNCTION_REF="<Fill the path to the output directory of 01.prep.sh.>"
#####################################################################################################
lead_file=pd.read_table(LEAD,header=None)
for i in range(1,24):
	code= 'anno_{} = pd.read_table("{}"+str({})+".anno.tsv.change")'.format(i,FUNCTION_REF,i)
	exec(code)

for k in range(1,1001):
	all=pd.DataFrame()
	for l in range(1,len(lead_file)+1)):
		target=pd.read_table(RANDOMSNP_LD+"/"+str(k)+"/"+str(l)+".ld",delim_whitespace=True)
		if target.empty:
			continue
		targetR2=pd.DataFrame(target[(target["R2"] > 0.8)].reset_index(drop=True)["SNP_B"].tolist(),columns=["SNP_B"])
		CHR=target["CHR_A"][0]
		code1='anno=targetR2.merge(anno_{},on="SNP_B",how="left").iloc[:,1:].values.tolist()'.format(CHR)
		exec(code1)
		res = [ flatten for inner in anno for flatten in inner ]
		t=pd.DataFrame(list(set(res)),columns=[l]).T
		all=pd.concat([all,t])
	all.to_csv(RANDOMSNP_LD+"/"+str(k)+"/result",index=True,header=False,sep="\t")
