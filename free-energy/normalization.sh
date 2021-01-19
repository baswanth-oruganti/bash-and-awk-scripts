#!/bin/bash

max=$(awk '$1!="#!" {print}' COLVAR | awk 'BEGIN {max=0.0}; {if ($2>max) max=$2} END {printf "%.2f", max}')
min=$(awk '$1!="#!" {print}' COLVAR | awk 'BEGIN {min=100000}; {if ($2<min) min=$2} END {printf "%.2f", min}')


# min-max scaling or Normalization

awk '$1!="#!" {print}' COLVAR | awk -v "maxi=$max" -v "mini=$min" '{printf "%4.2f\n",($2-mini)/(maxi-mini)}'

