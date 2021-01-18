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
  grep CA $i.pdb > $i-CA.pdb #extract "CA" atoms of the protein
  cat $i-CA.pdb >> path.pdb
  echo "END" >> path.pdb
  rm $i-CA.pdb
 done

 # concatenate active structure at the end of the path

grep CA active-cl4.pdb > abl1-CA-active.pdb
cat abl1-CA-active.pdb >> path.pdb
echo "END" >> path.pdb
sed -i 's/1.00  0.00/1.00  1.00/g' path.pdb


