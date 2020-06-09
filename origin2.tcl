set sel [atomselect top all]
set output [open "/dev/shm/minmax_output.txt" w ]
puts $output [measure minmax $sel]
close $output
set output [open "/dev/shm/center_output.txt" w ]
puts $output [measure center $sel]
close $output
exit
