#/bin/python
import pandas as pd
import numpy as np
from statistics import mean, stdev

result=pd.DataFrame()
a=0
for f in ["exonic","splicing"]:
	result.loc[a,"Function"]=f
	case=0
	d=pd.read_table("~/GCMS/permutation.median.PC10/01data/case.ld/result")
	for i in range(len(d)):
		if f in d.loc[i,:].tolist():
			case=case+1
	control=[]
	for i in range(1,1001):
		d=pd.read_table("~/GCMS/permutation.median.PC10/01data/control.ld/"+str(i)+"/result",header=None)
		p_count=0
		for i in range(len(d)):
			if f in d.loc[i,:].tolist():
				p_count=p_count+1
		control.append(p_count)
	fold=case/mean(control)
	control_m=[ 0.0001 if i == 0 else i for i in control ]
	foldsort= sorted([float(case)/i for i in control_m])
	UCI=foldsort[974]
	LCI=foldsort[25]
	control.append(case)
	index=[i for i, x in enumerate(sorted(control)) if x == case]
	position=mean(index)
	pvalue=(500.5-abs(500.5-position))/500.5
	result.loc[a,"fold"]=fold
	result.loc[a,"LCI"]=LCI
	result.loc[a,"UCI"]=UCI
	result.loc[a,"pvalue"]=pvalue
	a=a+1

result.to_csv("result.xls",sep="\t",index=False)
