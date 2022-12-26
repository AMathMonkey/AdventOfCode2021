# Runs in under 4 minutes. Not as good as my Tcl implementation but eons better than Raku.

import Base.@kwdef

timelimit = 26

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

function getmax(valve, openvalves, timeremaining, who)
    timeremaining == 0 && return who == :me ? getmax(valves["AA"], openvalves, timelimit, :elephant) : 0

    cacheindex = "$(valve.name),$(join(openvalves, ' ')),$timeremaining,$who"
    haskey(cache, cacheindex) && return cache[cacheindex]

    timeremaining -= 1

    maxval = 0

    for destvalve in valve.tunnels
        maxval = max(maxval, getmax(valves[destvalve], openvalves, timeremaining, who))
    end

    if valve.rate > 0 && !(valve.name in openvalves)
        maxval = max(
            maxval,
            timeremaining * valve.rate + getmax(valve, sort([openvalves..., valve.name]), timeremaining, who)
        )
    end

    return cache[cacheindex] = maxval
end

println(getmax(valves["AA"], [], timelimit, :me))