#!/bin/python

import pandas as pd
import sys

d=pd.read_table("data/00_metabolite_data.xls")
batches = list(set(d["Batch"].tolist()))
result=[]
for b in batches:
    tmpd=d[(d["Batch"]==b)].iloc[:,2:].apply(lambda x:x/x.median())
    tmpdinfo=d[(d["Batch"]==b)].iloc[:,0:2]
    result.append(pd.concat([tmpdinfo,tmpd],axis=1))

result=pd.concat(result)
result.to_csv("data/01_metabolite_data_corrected.xls",sep="\t",index=False)
