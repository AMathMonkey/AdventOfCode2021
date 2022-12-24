my \timeLimit := 26;

my %valves;
my %cache;

for 'input.txt'.IO.lines -> $line {
    $line ~~ m:s/Valve (\w+) has flow rate\=(\d+)\; tunnels? leads? to valves? (.*)/;
    my ($valve, $rate, $tunnels) = $/.list;
    %valves{"$valve,rate"} = $rate.Int;
    %valves{"$valve,tunnels"} = $tunnels.split: ', '
}

sub getMax ($valve, @openValves is copy, $timeRemaining is copy, $who) {
    if $timeRemaining == 0 {
        return $who eq 'me' ?? getMax('AA', @openValves, timeLimit, 'elephant') !! 0
    }

    @openValves .= sort;
    
    my $cacheIndex = "$valve,@openValves<>,$timeRemaining,$who";

    if %cache{$cacheIndex}:exists {return %cache{$cacheIndex}}

    $timeRemaining -= 1;

    my $max = 0;

    for @(%valves{"$valve,tunnels"}) -> $destValve {
        $max = ($max, getMax($destValve, @openValves, $timeRemaining, $who)).max;
    }

    if %valves{"$valve,rate"} > 0 && $valve !(elem) @openValves {
        $max = (
            $max,
            $timeRemaining * %valves{"$valve,rate"} + getMax($valve, [|@openValves, $valve], $timeRemaining, $who) 
        ).max;
    }

    return %cache{$cacheIndex} = $max
}

say getMax('AA', (), timeLimit, 'me')
