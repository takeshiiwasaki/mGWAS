#!/bin/python

import pandas as pd
from scipy import stats
d=pd.read_table("data/02_metabolite_data_normalized.log.xls")
r=pd.DataFrame()
a=0
for i in range(2,len(d.columns)):
	r.loc[a,"Metabolite"]=d.columns[i]
	r.loc[a,"ShapiroResult"]=stats.shapiro(d[d.columns[i]])[1]
	a=a+1

r.to_csv("data/02_metabolite_data_normalized.log.ShapiroResult.xls",sep="\t",index=False)
