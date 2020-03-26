set selText {name CA and resid 70 to 376 856 to 889 900 to 1167}

set fit [atomselect top $selText]
set ref [atomselect top $selText frame 0]
set all [atomselect top all]

# Run RMSD-based alignment
set nf [molinfo top get numframes]
for {set i 1} {$i < $nf} {incr i} {
    $all frame $i 
    $fit frame $i
    $all move [measure fit $fit $ref]
}
$all delete   
$fit delete
$ref delete
# Run RMSD-based alignment

set solv [atomselect top "water or ions"]
volmap density $solv -res 1.0 -radscale 1.0 -weight mass -allframes -combine avg -mol top