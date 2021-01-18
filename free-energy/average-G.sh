#!/bin/bash


rm G-full.txt G-mean.txt G-sd.txt G-sem.txt
#concatenate files from different trajectories
 for i in {1..50} # i is the trajectory index
 do
  cat G$i.txt >> G-full.txt
 done


#calculate average G values

 awk '{sum+=$1} END {printf "%.1f\n", sum/500}' G-full.txt >> G-mean.txt

# calculation of standard deviation

 x=$(head -$i G-mean.txt| tail -1)
 awk -v "var=$x" '{sd+=($1-var)*($1-var)} END {printf "%.1f\n", (sd/499)**0.5}' G-full.txt >> G-sd.txt

#calculation of standard error of mean
awk '{printf "%.1f\n", $1/(500**0.5)}' G-sd.txt > G-sem.txt

