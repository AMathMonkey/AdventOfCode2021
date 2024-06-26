set input [open input.txt]

set timeLimit 30

while {[gets $input line] >= 0} {
    regexp {Valve (\w+) has flow rate=(\d+); tunnels? leads? to valves? (.*)} $line {} valve rate tunnels
    set valves($valve,rate) $rate
    set valves($valve,tunnels) [split [string map [list {, } ,] $tunnels] ,]
}

proc getMax {valve openValves timeRemaining} {
    global valves cache

    if {$timeRemaining == 0} {return 0}

    set cacheIndex "$valve,$openValves,$timeRemaining"
    if {[info exists cache($cacheIndex)]} {return $cache($cacheIndex)}

    incr timeRemaining -1

    set max 0

    foreach destValve $valves($valve,tunnels) {
        set val [getMax $destValve $openValves $timeRemaining]
        if {$val > $max} {set max $val}
    }

    if {$valves($valve,rate) > 0 && $valve ni $openValves} {
        set val [getMax $valve [lsort [concat $openValves $valve]] $timeRemaining]
        incr val [expr {$timeRemaining * $valves($valve,rate)}]
        if {$val > $max} {set max $val}
    }

    return [set cache($cacheIndex) $max]
}

puts [getMax AA [list] $timeLimit]
