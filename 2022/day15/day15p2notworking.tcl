set input [open input.txt]

set minRow 0
set minCol 0
set maxRow 4000000
set maxCol 4000000
while {[gets $input line] >= 0} {
    regexp {Sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)} $line {} sensorCol sensorRow beaconCol beaconRow
    set manhattan [expr {abs($sensorCol - $beaconCol) + abs($sensorRow - $beaconRow)}]
    lappend sensors $sensorRow $sensorCol $manhattan
}

for {set row $minRow} {$row <= $maxRow} {incr row} {
    for {set col $minCol} {$col <= $maxCol} {} {
        set fail false
        foreach {sensorRow sensorCol manhattan} $sensors {
            set pointDistance [expr {abs($sensorRow - $row) + abs($sensorCol - $col)}]
            if {$pointDistance <= $manhattan} {
                set fail true
                incr col [expr {$pointDistance - abs($sensorRow - $row) + 2}]
                break
            }
        }
        if {!$fail} {puts [expr {$row + $col * 4000000}]; exit 0}
    }
}
