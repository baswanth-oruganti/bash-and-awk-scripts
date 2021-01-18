#!/bin/bash

# Trajectory corrections by removing PBC, translations and rotations

rm rmsd-matrix/matrix.txt
rm  pdb/*.pdb
rm xvg/*.xvg


for i in {0..500}
do
 echo 1 | gmx trjconv -s ../abl1_ed.tpr -f ../abl1_ed_fit.xtc -o pdb/"$i".pdb -dump $i
done

echo 1 | gmx trjconv -s ../abl1_ed.tpr -f ../abl1_ed_fit.xtc -b 0 -e 500 -o eds.pdb


for ((i=0; i<=500; i++))
do
   echo 3 3 | gmx rms -f eds.pdb -s pdb/$i.pdb -o xvg/$i.xvg
   awk 'NR>18 {printf "%.2f\n", 10*$2}' xvg/$i.xvg >> rmsd-matrix/matrix.txt
  echo >> rmsd-matrix/matrix.txt
done


