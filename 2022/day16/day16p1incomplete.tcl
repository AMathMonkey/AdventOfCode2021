set input [open input.txt]

while {[gets $input line] >= 0} {
    regexp {Valve (\w+) has flow rate=(\d+); tunnels? leads? to valves? (.*)} $line {} valve rate tunnels
    set valves($valve,rate) $rate
    set valves($valve,tunnels) [split [string map [list {, } ,] $tunnels] ,]
    set valves($valve,open) false
}

foreach {key value} [array get valves *,tunnels] {
    lassign [split $key ,] valve
    puts "$valve has tunnels to: $value"
}