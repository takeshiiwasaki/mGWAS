#!/bin/bash
#$1 $2 permutation number
#$3 以降=function　(ex. nonsynonymous)

if [ $# = 10 ];then
grep -we "$3" -we "$4" -we "$5" -we "$6" -we "$7" -we "$8" -we "$9"  -we "${10}" 01data/case.ld/result | wc -l | awk '{print $1}' | sed '1s/^/number\n/g' > $3.case.csv
for i in `seq $1 $2`
do
grep -we "$3" -we "$4" -we "$5" -we "$6" -we "$7" -we "$8" -we "$9" -we "${10}" 01data/control.ld/$i/result | wc -l | awk '{print $1}'
done | sed '1s/^/number\n/g' > $3.control.csv
cat $3.control.csv | while read line; do if [ "$line" = '' ];then echo "0"; else  echo "$line"; fi; done > $3.control2.csv
mv $3.control2.csv $3.control.csv
python function.permutation.py $3.case.csv $3.control.csv
fi

if [ $# = 7 ]; then
grep -we "$3" -we "$4" -we "$5" -we "$6" -we "$7" 01data/case.ld/result | wc -l | awk '{print $1}' | sed '1s/^/number\n/g' > $3.case.csv
for i in `seq $1 $2`
do
grep -we "$3" -we "$4" -we "$5" -we "$6" -we "$7" 01data/control.ld/$i/result |  wc -l | awk '{print $1}'
done | sed '1s/^/number\n/g' > $3.control.csv
cat $3.control.csv | while read line; do if [ "$line" = '' ];then echo "0"; else  echo "$line"; fi; done > $3.control2.csv
mv $3.control2.csv $3.control.csv
python function.permutation.py $3.case.csv $3.control.csv
fi

if [ $# = 6 ]; then
grep -we "$3" -we "$4" -we "$5" -we "$6"  01data/case.ld/result |  wc -l | awk '{print $1}' | sed '1s/^/number\n/g' > $3.case.csv
for i in `seq $1 $2`
do
grep -we "$3" -we "$4" -we "$5" -we "$6" 01data/control.ld/$i/result |  wc -l | awk '{print $1}'
done | sed '1s/^/number\n/g' > $3.control.csv
cat $3.control.csv | while read line; do if [ "$line" = '' ];then echo "0"; else  echo "$line"; fi; done > $3.control2.csv
mv $3.control2.csv $3.control.csv
python function.permutation.py $3.case.csv $3.control.csv
fi

if [ $# = 5 ]; then
grep -we "$3" -we "$4" -we "$5"   01data/case.ld/result |  wc -l | awk '{print $1}' | sed '1s/^/number\n/g' > $3.case.csv
for i in `seq $1 $2`
do
grep -we "$3" -we "$4" -we "$5"  01data/control.ld/$i/result |  wc -l | awk '{print $1}'
done | sed '1s/^/number\n/g' > $3.control.csv
cat $3.control.csv | while read line; do if [ "$line" = '' ];then echo "0"; else  echo "$line"; fi; done > $3.control2.csv
mv $3.control2.csv $3.control.csv
python function.permutation.py $3.case.csv $3.control.csv
fi


if [ $# = 4 ]; then
grep -we "$3" -we "$4"  01data/case.ld/result | wc -l | awk '{print $1}' | sed '1s/^/number\n/g' > $3.case.csv
for i in `seq $1 $2`
do
grep -we "$3" -we "$4"  01data/control.ld/$i/result |  wc -l | awk '{print $1}'
done | sed '1s/^/number\n/g' > $3.control.csv
cat $3.control.csv | while read line; do if [ "$line" = '' ];then echo "0"; else  echo "$line"; fi; done > $3.control2.csv
mv $3.control2.csv $3.control.csv
python function.permutation.py $3.case.csv $3.control.csv
fi

if [ $# = 3 ]; then
grep -we "$3"   01data/case.ld/result |  wc -l | awk '{print $1}' | sed '1s/^/number\n/g' > $3.case.csv
for i in `seq $1 $2`
do
grep -we "$3" 01data/control.ld/$i/result |  wc -l | awk '{print $1}'
done | sed '1s/^/number\n/g' > $3.control.csv
cat $3.control.csv | while read line; do if [ "$line" = '' ];then echo "0"; else  echo "$line"; fi; done > $3.control2.csv
mv $3.control2.csv $3.control.csv
python function.permutation.py $3.case.csv $3.control.csv
fi

