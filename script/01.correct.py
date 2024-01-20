#!/bin/python
#The first argument: metabolite data (example data:"data/00_metabolite_data.xls")
#The second argument: output file name (example data:"data/01_metabolite_data_corrected.xls")

import pandas as pd
import sys


d=pd.read_table(sys.argv[1])
batches = list(set(d["Batch"].tolist()))
result=[]
for b in batches:
    tmpd=d[(d["Batch"]==b)].iloc[:,2:].apply(lambda x:x/x.median())
    tmpdinfo=d[(d["Batch"]==b)].iloc[:,0:2]
    result.append(pd.concat([tmpdinfo,tmpd],axis=1))

result=pd.concat(result)
result.to_csv(sys.argv[2],sep="\t",index=False)
