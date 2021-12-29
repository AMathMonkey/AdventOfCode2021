use strict;
use warnings;
use Data::Dumper;
use List::Util qw(sum);
use v5.28.1;

my $inputfile = IO::File->new('./input.txt');

my $input = <$inputfile>;
chomp $input;

my @fish = split ',', $input;

my %timers;
for my $fish (@fish) {
    $timers{$fish} += 1;
}

for (1..256) {
    my %newtimers;
    while (my ($time, $fish) = each %timers) {
        if ($time == 0) {
            $newtimers{6} += $fish;
            $newtimers{8} += $fish;
        }
        else {
            $newtimers{$time - 1} += $fish;
        }
    }
    %timers = %newtimers;
}

say sum(values %timers)