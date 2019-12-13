set sel [atomselect top all]
measure minmax $sel
measure center $sel
exit
