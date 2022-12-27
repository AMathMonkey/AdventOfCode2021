# Raku is nightmarishly slow; this port of day6p2.tcl (which runs in 1m25s)
# takes 8h 6m 41s to run in Raku. That's WTF-worthy. The memory usage grows and shrinks;
# I think the garbage collector is too eager and it's wasting time. Unsure though
# why this is unrivaled in its slowness. Is Raku faster on Linux? I hope so.

my \timeLimit := 26;

my %valves;
my %cache;

class Valve {
    has $.name;
    has $.rate;
    has @.tunnels;
}

for 'input.txt'.IO.lines {
    my ($name, $rate, $tunnels) := 
        m:s/Valve (\w+) has flow rate\=(\d+)\; tunnels? leads? to valves? (.*)/;
    %valves{$name} = Valve.new(
        :$name,
        :rate($rate.Int),
        :tunnels($tunnels.split: ', '),
    );
}

constant me = 0;
constant elephant = 1;

sub getMax($valve, @openValves, $timeRemaining is copy, $who) {
    return $who == me ?? getMax(%valves<AA>, @openValves, timeLimit, elephant) !! 0 unless $timeRemaining;

    my $cacheIndex = "{$valve.name},@openValves<>,$timeRemaining,$who";
    .return with %cache{$cacheIndex};

    --$timeRemaining;

    my $max = 0;

    for $valve.tunnels -> $destValve {
        given getMax(%valves{$destValve}, @openValves, $timeRemaining, $who) {
            $max = $_ when $_ > $max
        }
    }

    if $valve.rate && $valve.name !(elem) @openValves {
        given $timeRemaining * $valve.rate + getMax($valve, [|@openValves, $valve.name].sort, $timeRemaining, $who) {
            $max = $_ when $_ > $max;
        }
    }

    return %cache{$cacheIndex} = $max
}

say getMax(%valves<AA>, [], timeLimit, me)
