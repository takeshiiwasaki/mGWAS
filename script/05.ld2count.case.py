#!/bin/python

import sys
import pandas as pd
import collections
import itertools

#####################################################################################################
LEAD="data/04_get_ld.txt"          #Fill the path to input file of "04_get_ld.lead.snp.sh."
LEAD_LD="04_get_ld_lead_snp"       #Fill the path to the output directory of "04_get_ld.lead.snp.sh."
FUNCTION_REF="function_of_variant" #Fill the path to the output directory of "01.prep.sh."
#####################################################################################################

lead_file=pd.read_table(LEAD,header=None)
for i in range(1,24):
	code= 'anno_{} = pd.read_table("{}"+"/"+str({})+".anno.tsv")'.format(i,FUNCTION_REF,i)
	exec(code)

all=pd.DataFrame()
for l in range(1,len(lead_file)+1):
	target=pd.read_table(LEAD_LD+"/"+str(l)+".ld",delim_whitespace=True)
	if target.empty:
		continue
	targetR2=target[(target["R2"] > 0.8)].reset_index(drop=True)
	CHR=targetR2["CHR_A"][0]
	code1='anno=targetR2.merge(anno_{},on="SNP_B",how="left").iloc[:,12:].values.tolist()'.format(CHR)
	exec(code1)
	res = [ flatten for inner in anno for flatten in inner ]
	t=pd.DataFrame(list(set(res)), columns=[l]).T
	all=pd.concat([all,t])

all.to_csv(LEAD_LD+"/result",sep="\t")

