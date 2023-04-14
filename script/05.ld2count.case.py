#!/bin/python

import sys
import pandas as pd
import collections
import itertools

for i in range(1,24):
	code= 'anno_{} = pd.read_table("/home/tiwasaki/GCMS/permutation.spline3/1K/function/"+str({})+".anno.tsv")'.format(i,i)
	exec(code)

lead=range(1,76)
#ex=[27,30,86,97,98,107,108,112,115,116,117,118] ##30,86: chrX
#for i in ex:
#	lead.remove(i)

all=pd.DataFrame()
for l in lead:
	target=pd.read_table("/home/tiwasaki/GCMS/permutation.median.PC10/01data/case.ld/"+str(l)+".ld",delim_whitespace=True)
	if target.empty:
		continue
	targetR2=target[(target["R2"] > 0.8)].reset_index(drop=True)
	CHR=targetR2["CHR_A"][0]
	code1='anno=targetR2.merge(anno_{},on="SNP_B",how="left").iloc[:,12:].values.tolist()'.format(CHR)
	exec(code1)
	res = [ flatten for inner in anno for flatten in inner ]
	t=pd.DataFrame(list(set(res)), columns=[l]).T
	all=pd.concat([all,t])
	#all.append(list(set(res)))
#res2 = [ flatten for inner in all for flatten in inner ]
#annoresult = collections.Counter(res2)
#result=pd.Series(annoresult)
all.to_csv("/home/tiwasaki/GCMS/permutation.median.PC10/01data/case.ld/result",sep="\t")
#result.to_csv("/home/tiwasaki/GCMS/permutation.median/01data/case.ld/result2",sep="\t")

