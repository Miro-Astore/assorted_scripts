#!/bin/bash
prepare_namd_coordinates () {
cat $1 | grep ATOM | sed "s/WT[0-9]*//" | awk '{print $(NF-5)}' | tr '\n' ' ' | python $HOME/python_scripts/cellsize.py | sed  "s/^/cellBasisVector1\t/" | sed "1s/$/\t0\t0/" 
cat $1 | grep ATOM | sed "s/WT[0-9]*//" | awk '{print $(NF-4)}' | tr '\n' ' ' | python $HOME/python_scripts/cellsize.py | sed "s/^/cellBasisVector2\t0\t/" | sed "s/$/\t0/"
cat $1 | grep ATOM | sed "s/WT[0-9]*//" |  awk '{print $(NF-3)}' | tr '\n' ' ' | python $HOME/python_scripts/cellsize.py |  sed "s/^/cellBasisVector3\t0\t0\t/" 
echo "cellOrigin" | tr '\n' '\t'
#cat $1 | grep ATOM | sed "s/WT[0-9]*//" |  awk '{print $(NF-5)}'  | python $HOME/python_scripts/cellmid.py | tr '\n' '\t' 
#echo -e '\t' | tr '\n' ' ' 
#cat $1 | grep ATOM | sed "s/WT[0-9]*//" |  awk '{print  $(NF-4)}'  | python $HOME/python_scripts/cellmid.py | tr '\n' '\t' 
#echo -e '\t' | tr '\n' ' ' 
#cat $1 | grep ATOM | sed "s/WT[0-9]*//" |  awk '{print  $(NF-3)}'  | python $HOME/python_scripts/cellmid.py | tr ' ' '\t' 
vmd -dispdev text -e origin.tcl $1 2> /dev/null | grep '^-\|^[0-9]'
}

