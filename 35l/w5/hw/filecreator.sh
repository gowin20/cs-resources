#!/bin/bash
num=$1
newNum=$(( num / 10 ))
for i in $(seq 1 $newNum );
do
	for j in $(seq 0 9);
	do
		echo $j >> $2
	done
done
sed -i ':a;N;$!ba;s/\n/ /g' $2