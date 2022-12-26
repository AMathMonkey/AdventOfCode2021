# Still slower than my Tcl implementation but not too bad. Takes <8 seconds.

import Base.@kwdef

timelimit = 30

valves = Dict()
cache = Dict()

@kwdef struct Valve
    name
    rate
    tunnels
end

for line in eachline("input.txt")
    @something (m = match(r"Valve (\w+) has flow rate=(\d+); tunnels? leads? to valves? (.*)", line)) continue
    (name, rate, tunnels) = m
    valves[name] = Valve(
        name=name,
        rate=parse(Int, rate),
        tunnels=split(tunnels, ", "),
    )
end

function getmax(valve, openvalves, timeremaining)
    timeremaining == 0 && return 0

    cacheindex = "$(valve.name),$(join(openvalves, ' ')),$timeremaining"
    haskey(cache, cacheindex) && return cache[cacheindex]

    timeremaining -= 1

    maxval = 0

    for destvalve in valve.tunnels
        maxval = max(maxval, getmax(valves[destvalve], openvalves, timeremaining))
    end

    if valve.rate > 0 && !(valve.name in openvalves)
        maxval = max(
            maxval,
            timeremaining * valve.rate + getmax(valve, sort([openvalves..., valve.name]), timeremaining)
        )
    end

    return cache[cacheindex] = maxval
end

println(getmax(valves["AA"], [], timelimit))