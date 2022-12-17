set input [open input.txt]

set timeLimit 26

while {[gets $input line] >= 0} {
    regexp {Valve (\w+) has flow rate=(\d+); tunnels? leads? to valves? (.*)} $line {} valve rate tunnels
    set valves($valve,rate) $rate
    set valves($valve,tunnels) [split [string map [list {, } ,] $tunnels] ,]
}

proc getMax {myValve elephantValve openValves timeElapsed} {
    global valves cache timeLimit

    if {$timeElapsed == $timeLimit} {return 0}

    lassign [lsort [list $myValve $elephantValve]] myValve elephantValve
    set openValves [lsort $openValves]
    set cacheIndex "$myValve,$elephantValve,$openValves,$timeElapsed"

    if {[info exists cache($cacheIndex)]} {return $cache($cacheIndex)}

    incr timeElapsed

    set max -Inf

    set pressureReleased 0
    foreach openValve $openValves {incr pressureReleased $valves($openValve,rate)}

    foreach myDestValve $valves($myValve,tunnels) {
        foreach elephantDestValve $valves($elephantValve,tunnels) {
            set val [getMax $myDestValve $elephantDestValve $openValves $timeElapsed]
            incr val $pressureReleased
            if {$val > $max} {set max $val}
        }
    }

    set myValveClosed [expr {$myValve ni $openValves}]
    set elephantValveClosed [expr {$elephantValve ni $openValves}]
    if {$myValveClosed && $valves($myValve,rate) > 0 && $timeElapsed < $timeLimit} {
        set newOpenValves [concat $openValves $myValve]

        foreach elephantDestValve $valves($elephantValve,tunnels) {
            set val [getMax $myValve $elephantDestValve $newOpenValves $timeElapsed]
            incr val $pressureReleased
            if {$val > $max} {set max $val}
        }
    }

    if {$elephantValveClosed && $myValve ne $elephantValve && $valves($elephantValve,rate) > 0 && $timeElapsed < $timeLimit} {
        set newOpenValves [concat $openValves $elephantValve]

        foreach myDestValve $valves($myValve,tunnels) {
            set val [getMax $myDestValve $elephantValve $newOpenValves $timeElapsed]
            incr val $pressureReleased
            if {$val > $max} {set max $val}
        }
    }

    if {$myValveClosed && $elephantValveClosed && $myValve ne $elephantValve && $valves($myValve,rate) > 0 && $valves($elephantValve,rate) > 0 && $timeElapsed < $timeLimit} {
        set newOpenValves [concat $openValves $myValve $elephantValve]

        set val [getMax $myValve $elephantValve $newOpenValves $timeElapsed]
        incr val $pressureReleased
        if {$val > $max} {set max $val}
    }
    
    return [set cache($cacheIndex) $max]
}

puts [getMax AA AA [list] 0]
