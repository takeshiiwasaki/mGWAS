import os
import sys
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import pandas as pd
import numpy as np
import random
from scipy.stats import norm
from statistics import mean, stdev
import csv

case=pd.read_csv(sys.argv[1])
control=pd.read_csv(sys.argv[2])
mincontrol=control.number.min()
maxcontrol=control.number.max()
control_list=control.number.tolist()
fold=case.number[0]/mean(control_list)
control_listm=[ 0.0001 if i == 0 else i for i in control_list]
foldsort= sorted([ float(case.number[0])/i for i in control_listm])
UCI=foldsort[974]
LCI=foldsort[25]
control_list.append(case.number[0])
index=[i for i, x in enumerate(sorted(control_list)) if x == case.number[0]]
position=mean(index)
pvalue=(500.5-abs(500.5-position))/500.5
r=pd.DataFrame()
r.loc[0,"fold"]=fold
r.loc[0,"LCI"]=LCI
r.loc[0,"UCI"]=UCI
r.loc[0,"pvalue"]=pvalue
print(r)

