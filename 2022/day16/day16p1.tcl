set input [open input.txt]

set timeLimit 30

while {[gets $input line] >= 0} {
    regexp {Valve (\w+) has flow rate=(\d+); tunnels? leads? to valves? (.*)} $line {} valve rate tunnels
    set valves($valve,rate) $rate
    set valves($valve,tunnels) [split [string map [list {, } ,] $tunnels] ,]
}

proc getMax {valve openValves timeElapsed} {
    global valves cache timeLimit

    if {$timeElapsed == $timeLimit} {return 0}

    set openValves [lsort $openValves]
    set cacheIndex "$valve,$openValves,$timeElapsed"

    if {[info exists cache($cacheIndex)]} {return $cache($cacheIndex)}

    incr timeElapsed

    set max -Inf

    set pressureReleased 0
    foreach openValve $openValves {incr pressureReleased $valves($openValve,rate)}

    foreach destValve $valves($valve,tunnels) {
        set val [getMax $destValve $openValves $timeElapsed]
        incr val $pressureReleased
        if {$val > $max} {set max $val}
    }

    if {$valves($valve,rate) > 0 && $timeElapsed < $timeLimit && $valve ni $openValves} {
        set pressureReleased [expr {$pressureReleased * 2 + $valves($valve,rate)}]
        set openValves [lsort [concat $openValves $valve]]
        incr timeElapsed

        foreach destValve $valves($valve,tunnels) {
            set val [getMax $destValve $openValves $timeElapsed]
            incr val $pressureReleased
            if {$val > $max} {set max $val}
        }
    }
    
    return [set cache($cacheIndex) $max]
}

puts [getMax AA [list] 0]
