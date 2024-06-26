set input [open input.txt]

set timeLimit 26

while {[gets $input line] >= 0} {
    regexp {Valve (\w+) has flow rate=(\d+); tunnels? leads? to valves? (.*)} $line {} valve rate tunnels
    set valves($valve,rate) $rate
    set valves($valve,tunnels) [split [string map [list {, } ,] $tunnels] ,]
}

proc getMax {valve openValves timeRemaining who} {
    global valves cache timeLimit

    if {$timeRemaining == 0} {
        if {$who eq {me}} {
            return [getMax AA $openValves $timeLimit elephant]
        } else {return 0}
    }

    set cacheIndex "$valve,$openValves,$timeRemaining,$who"
    if {[info exists cache($cacheIndex)]} {return $cache($cacheIndex)}

    incr timeRemaining -1

    set max 0

    foreach destValve $valves($valve,tunnels) {
        set val [getMax $destValve $openValves $timeRemaining $who]
        if {$val > $max} {set max $val}
    }

    if {$valves($valve,rate) > 0 && $valve ni $openValves} {
        set val [getMax $valve [lsort [concat $openValves $valve]] $timeRemaining $who]
        incr val [expr {$timeRemaining * $valves($valve,rate)}]
        if {$val > $max} {set max $val}
    }

    return [set cache($cacheIndex) $max]
}

puts [getMax AA [list] $timeLimit me]
