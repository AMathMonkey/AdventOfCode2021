# Raku is nightmarishly slow; this direct port from Tcl (which runs in <4 seconds)
# takes over a minute to run, and the port of part 2 doesn't even finish in a reasonable time

my \timeLimit := 30;

my %valves;
my %cache;

for 'input.txt'.IO.lines -> $line {
    $line ~~ m:s/Valve (\w+) has flow rate\=(\d+)\; tunnels? leads? to valves? (.*)/;
    my ($valve, $rate, $tunnels) = $/.list;
    %valves{"$valve,rate"} = $rate.Int;
    %valves{"$valve,tunnels"} = $tunnels.split: ', '
}

sub getMax ($valve, @openValves is copy, $timeRemaining is copy) {
    return 0 if $timeRemaining == 0;

    @openValves .= sort;

    my $cacheIndex = "$valve,@openValves<>,$timeRemaining";

    if %cache{$cacheIndex}:exists {return %cache{$cacheIndex}}

    $timeRemaining -= 1;

    my $max = 0;

    for @(%valves{"$valve,tunnels"}) -> $destValve {
        $max = ($max, getMax($destValve, @openValves, $timeRemaining)).max;
    }

    if %valves{"$valve,rate"} > 0 && $valve !(elem) @openValves {
        $max = (
            $max,
            $timeRemaining * %valves{"$valve,rate"} + getMax($valve, [|@openValves, $valve], $timeRemaining) 
        ).max;
    }

    return %cache{$cacheIndex} = $max
}

say getMax('AA', [], timeLimit)
