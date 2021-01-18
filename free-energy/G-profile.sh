#!/bin/bash


rm G-*
#concatenate files from different configurations
 for i in {1..10}
 do
  cat $i/G-mean.txt >> G-profile.txt
  cat $i/G-sem.txt >> G-sem.txt
 done


G_min=$(awk 'NR==1{print $1}' G-profile.txt)
awk -v "var=$G_min" '{print $1-var}' G-profile.txt > G-plot.txt

