use strict;
use warnings;
use Data::Dumper;
use v5.28.1;

my $inputfile = IO::File->new('./input.txt');

chomp(my @input = <$inputfile>);

sub run {
    my @instructions = shift->@*;
    my @inputs = shift->@*;

    my ($w, $x, $y, $z) = (0, 0, 0, 0);

    foreach (@instructions) {
        if (/inp (\D)/) {
            ${$1} = shift @inputs;
        } elsif (/add (\D) (\D)?(-?\d+)?/) {
            ${$1} += defined($2) ? ${$2} : $3
        } elsif (/mul (\D) (\D)?(-?\d+)?/) {
            ${$1} *= defined($2) ? ${$2} : $3
        } elsif (/div (\D) (\D)?(-?\d+)?/) {
            ${$1} /= defined($2) ? ${$2} : $3;
            ${$1} = int ${$1}
        } elsif (/mod (\D) (\D)?(-?\d+)?/) {
            ${$1} %= defined($2) ? ${$2} : $3
        } elsif (/eql (\D) (\D)?(-?\d+)?/) {
            ${$1} = (${$1} == (defined($2) ? ${$2} : $3)) ? 1 : 0
        } else {die "Invalid instruction $_\n"}
    }
}
