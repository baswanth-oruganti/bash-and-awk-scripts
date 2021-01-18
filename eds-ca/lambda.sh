#!/bin/bash

rm final-rmsd.txt

k=$(wc -l snap-time-mtd.txt | awk '{print $1}') # number of snapshots
z=$(($k+1)) # variable defined to copy target inactive structure to snapshots

for ((i=1 ;i<=$z; i++))
do
 awk -v "var=$i" 'NR==var+1 {print}' mat$i.txt >> final-rmsd.txt
 tail -1 mat$i.txt >> rmsd-tar.xvg
done

awk -v "var=$k" '{sum+=$1*$1} END {print sum, (2.3*(var))/sum}' final-rmsd.txt > lambda.txt

