use strict;
use warnings;
use Data::Dumper;
use v5.28.1;

my $inputfile = IO::File->new('./input.txt');

chomp(my @input = <$inputfile>);

sub run {
    my @instructions = shift->@*;
    my @inputs = shift->@*;

    my %vars = (w => 0, x => 0, y => 0, z => 0);

    foreach (@instructions) {
        if (/^inp (\D)/) {
            $vars{$1} = shift @inputs;
        } elsif (/^add (\D) ([^-\d])?(-?\d+)?/) {
            $vars{$1} += defined($2) ? $vars{$2} : $3
        } elsif (/^mul (\D) ([^-\d])?(-?\d+)?/) {
            $vars{$1} *= defined($2) ? $vars{$2} : $3;
        } elsif (/^div (\D) ([^-\d])?(-?\d+)?/) {
            $vars{$1} /= defined($2) ? $vars{$2} : $3;
            $vars{$1} = int $vars{$1}
        } elsif (/^mod (\D) ([^-\d])?(-?\d+)?/) {
            $vars{$1} %= defined($2) ? $vars{$2} : $3
        } elsif (/^eql (\D) ([^-\d])?(-?\d+)?/) {
            $vars{$1} = ($vars{$1} == (defined($2) ? $vars{$2} : $3)) ? 1 : 0
        } else {die "Invalid instruction $_\n"}
    }
    $vars{z} == 0
}

for (my $i = 99999999999999; $i >= 11111111111111; do {$i--} while ($i =~ /0/)) {
    if (run(\@input, [split '', $i])) {
        say $i;
        last;
    }
}

# say run(\@input, [split '', 13579246899999])