#!/bin/bash
prepcoords () {
x=$(vmd -dispdev text -startup /home/miro/python_scripts/dummy_vmdrc.tcl $1 -e /home/miro/python_scripts/origin.tcl 2> /dev/null | grep -E  ^-\|^[0-9]\|^{)
echo $x | sed 's/[{}]//g' | python /home/miro/python_scripts/cellmid.py

unset x
}

