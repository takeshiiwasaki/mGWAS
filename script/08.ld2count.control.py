#!/bin/python

import sys
import pandas as pd
import collections
import itertools

taiou=pd.read_table("/home/tiwasaki/GCMS/permutation.qtl/1K/function/taiou.tsv")

for i in range(1,24):
	code= 'anno_{} = pd.read_table("/home/tiwasaki/GCMS/permutation.qtl/1K/function/"+str({})+".anno.tsv.change")'.format(i,i)
	exec(code)


lead=range(1,76)

for k in range(int(sys.argv[1]),int(sys.argv[2])):
	all=pd.DataFrame()
	for l in lead:
		target=pd.read_table("/home/tiwasaki/GCMS/permutation.median.PC10/01data/control.ld/"+str(k)+"/"+str(l)+".ld",delim_whitespace=True)
		if target.empty:
			continue
		CHR=target["CHR_A"][0]
		targetR2=pd.DataFrame(target[(target["R2"] > 0.8)].reset_index(drop=True)["SNP_B"].tolist(),columns=["SNP_B"])
		code1='anno=targetR2.merge(anno_{},on="SNP_B",how="left").iloc[:,1:].values.tolist()'.format(CHR)
		exec(code1)
		res = [ flatten for inner in anno for flatten in inner ]
		a=pd.DataFrame(list(set(res)), columns=['index'])  ##Function is number in this stage
		t=pd.DataFrame(a.merge(taiou,on="index")["Function"].tolist(),columns=[l]).T
		all=pd.concat([all,t])
		#all.append(list(set(res)))
#	res2 = [ flatten for inner in all for flatten in inner ]
#	annoresult = collections.Counter(res2)
#	result=pd.Series(annoresult)
#	result=pd.DataFrame(result).reset_index()
#	result.merge(taiou,on="index").iloc[:,[2,1]].to_csv("/home/tiwasaki/GCMS/permutation.median/01data/control.dist.ld/"+str(k)+"/result2",index=False,header=False,sep="\t")
	all.to_csv("/home/tiwasaki/GCMS/permutation.median.PC10/01data/control.ld/"+str(k)+"/result",index=True,header=False,sep="\t")
