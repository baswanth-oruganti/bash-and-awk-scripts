#!/bin/bash

rm path.pdb
rm mat*
rm *.xvg

# Generate path for metadynamics

k=$(wc -l snap-time-mtd.txt | awk '{print $1}') #extract times from snap-time-mtd.txt

 for ((i=1; i<=$k; i++))
 do
  time=$(awk -v "j=$i" 'NR==j {print}' snap-time-mtd.txt)
  echo 1 | gmx  trjconv -s inactive.pdb -f ../abl1_ed_fit.xtc -b $time -e $time -o $i.pdb  #extract full protein
  sed '/H$/d' $i.pdb > $i-nH.pdb #extract "nH" atoms of the protein
  awk 'NR>5 {print}' $i-nH.pdb >> path.pdb
  echo "END" >> path.pdb
  rm $i-nH.pdb
 done

 # concatenate active structure at the end of the path

echo 1 | gmx  trjconv -s inactive.pdb -f active-cl4.pdb -o active.pdb  #extract full protein
sed '/H$/d' active.pdb > abl1-nH-active.pdb
cat abl1-nH-active.pdb >> path.pdb
echo "END" >> path.pdb
sed -i 's/1.00  0.00/1.00  1.00/g' path.pdb

sed -i 's/TER//g' path.pdb 
sed -i 's/ENDMDL//g' path.pdb 
sed -i '/^$/d' path.pdb  # Delete Empty lines

