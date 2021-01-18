#!/bin/bash

rm snap-time-mtd.txt
limit=0.45

for ((i=1; i<=501; i=$j))
do
  echo 3 3 | gmx rms -f pdb/$(($i-1)).pdb -s active-cl4.pdb -o test.xvg
  rm '#'*
  rmsd=$(tail -1 test.xvg | awk '{print $2*10}')
  check=$(echo "$rmsd > $limit" | bc)
  if [ $check == 1 ]
  then
   j=$(awk -v "var=$i" 'BEGIN {RS=""; FS="\n"} NR==var {for(k=var;k<=NF;k++){ if($k>=0.46 && $k<=0.60){print k; break} } } END{}' rmsd-matrix/matrix.txt)
   echo $rmsd
   echo $(($i-1)) >> snap-time-mtd.txt
  else
   break
  fi
done

