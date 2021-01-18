#!/bin/bash


k=$(wc -l snap-time-mtd.txt | awk '{print $1}') # number of snapshots
z=$(($k+1)) # variable defined to copy target active structure to snapshots
cp active-cl4.pdb $z.pdb 

rm mat*

#calculate rmsd of each snapshot with all snapshots 

for ((i=1; i<=$z; i++))
do
  for ((l=1; l<=$z; l++))
  do
   echo 2 2 | gmx rms -f $i.pdb -s $l.pdb -o $i-$l.xvg
   tail -1 $i-$l.xvg | awk '{print $2}' >> mat$l.txt # rmsd of each snapshot with all snapshots
  done
done



# concatenate all columns into a rmsd matrix

for ((col=1; col<=$z; col++))
do
 awk '{print}' mat$col.txt >> matrix.txt
 echo >> matrix.txt
done
rm *.xvg
