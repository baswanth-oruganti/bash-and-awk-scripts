#!/bin/bash

#!/bin/sh
#SBATCH -A snic2020-5-62
#SBATCH -t 8:00:00
#SBATCH -n 1
#SBATCH --tasks-per-node=20

#SBATCH --mail-type=ALL

# job name and output file names
#SBATCH -J md
#SBATCH -e md_%j.err
#SBATCH -o md_%j.out

# load the relevant modules
module load GCC/5.4.0-2.26  OpenMPI/1.10.3
module load GROMACS/5.1.4-hybrid


for k in {1..1} # k is the configuration index
do
  cd $k
  rm H*
  rm S*
  rm H_TS*
  rm G*
  for j in {1..50} # j is the trajectory index
  do
  #correcting the trajectory for PBC
  echo 1 0| gmx trjconv -s $k-eql-$j.tpr -f $k-eql-$j.xtc -o $k-eql-noPBC-$j.xtc -pbc mol -center -ur compact
  echo 2 0 | gmx trjconv -s $k-eql-$j.tpr -f $k-eql-noPBC-$j.xtc -o $k-eql-fit-$j.xtc -fit rot+trans
  echo 0 | gmx trjconv -s $k-eql-$j.tpr -f $k-eql-fit-$j.xtc -o $k-eql-$j.pdb -dump 0
  rm $k-eql-noPBC-$j.xtc
  for i in {200..470..30} # i is the window index: each window of 30ps, total 10 windows
   do
    rm '#'*
    #calculate enthalpy(H) first
    echo 25 0 | gmx energy -b $((i+1)) -e $((i+30)) -f $k-eql-$j.edr -o $j-$i.xvg > $j-$i.txt
    l=$(tail -1 $j-$i.txt | awk '{printf "%.1f\n", $2/4.184}')
    echo $l >> H$j.txt

    #calculate entropy(S) using Schlitter approximation and calculate T*S next
    echo 2 2 | gmx covar -f $k-eql-fit-$j.xtc -s $k-eql-$j.tpr -b $((i+1)) -e $((i+30)) -ascii -o eigenval-$j-$i.xvg -v eigenvec-$j-$i.trr
    echo 2 2 | gmx anaeig -f $k-eql-fit-$j.xtc -s $k-eql-$j.tpr -b $((i+1)) -e $((i+30)) -v  eigenvec-$j-$i.trr -eig eigenval-$j-$i.xvg -entropy  -temp 300 | awk 'NR==2 {print $9/(1000*4.184)}' >> S$j.txt
   done

   #calculate TS in kcal/mol and G=H-TS in kcal/mol
   paste <(awk '{printf "%.1f\n", $1}' H$j.txt) <(awk '{printf "%.1f\n", 300*$1}' S$j.txt) >> H_TS$j.txt
   paste <(awk '{printf "%.1f\n", ($1-$2)}' H_TS$j.txt) >> G$j.txt
   rm eigenvec-$j* eigenval-$j* *.xvg
  done
  cd ..
done

