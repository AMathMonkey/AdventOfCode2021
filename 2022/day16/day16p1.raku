# Raku is nightmarishly slow; this port of day6p1.tcl (which runs in <4 seconds)
# takes almost a minute to run.

my \timeLimit := 30;

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

sub getMax($valve, @openValves, $timeRemaining is copy) {
    return 0 unless $timeRemaining;

    my $cacheIndex = "{$valve.name},@openValves<>,$timeRemaining";
    .return with %cache{$cacheIndex};

    --$timeRemaining;

    my $max = 0;

    for $valve.tunnels -> $destValve {
        given getMax(%valves{$destValve}, @openValves, $timeRemaining) {
            $max = $_ when $_ > $max
        }
    }

    if $valve.rate > 0 && $valve.name !(elem) @openValves {
        given $timeRemaining * $valve.rate + getMax($valve, [|@openValves, $valve.name].sort, $timeRemaining) {
            $max = $_ when $_ > $max;
        }
    }

    return %cache{$cacheIndex} = $max
}

say getMax(%valves<AA>, [], timeLimit);
