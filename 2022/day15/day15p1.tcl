set input [open input.txt]

set answerRow 2000000

set minRow Inf
set minCol Inf
set maxRow -Inf
set maxCol -Inf
while {[gets $input line] >= 0} {
    regexp {Sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)} $line {} sensorCol sensorRow beaconCol beaconRow
    set grid($sensorRow,$sensorCol) S
    set grid($beaconRow,$beaconCol) B
    set manhattan [expr {abs($sensorCol - $beaconCol) + abs($sensorRow - $beaconRow)}]

    if {$sensorRow - $manhattan < $minRow} {set minRow [expr {$sensorRow - $manhattan}]}
    if {$sensorRow + $manhattan > $maxRow} {set maxRow [expr {$sensorRow + $manhattan}]}
    if {$sensorCol - $manhattan < $minCol} {set minCol [expr {$sensorCol - $manhattan}]}
    if {$sensorCol + $manhattan > $maxCol} {set maxCol [expr {$sensorCol + $manhattan}]}

    lappend sensors $sensorRow $sensorCol $manhattan
}

set row $answerRow
for {set col $minCol} {$col <= $maxCol} {incr col} {
    set val [expr {[info exists grid($row,$col)] ? $grid($row,$col) : {.}}]
    if {$val eq {B}} {continue}
    foreach {sensorRow sensorCol manhattan} $sensors {
        if {(abs($sensorCol - $col) + abs($sensorRow - $row)) <= $manhattan} {incr result; break}
    }
}

puts $result