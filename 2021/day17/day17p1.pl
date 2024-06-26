use strict;
use warnings;
use Data::Dumper;
use v5.28.1;
use List::Util qw(max);

my $inputfile = IO::File->new('./input.txt');

my $input = <$inputfile>;
chomp $input;

my ($xlower, $xupper, $ylower, $yupper) =
    $input =~ /target area: x=(-?\d+)\.\.(-?\d+), y=(-?\d+)\.\.(-?\d+)/;

sub testvels { my ($xvel, $yvel) = @_;
    my ($x, $y) = (0, 0);
    my $maxy = 0;
    while (1) {
        $x += $xvel;
        $y += $yvel;
        $maxy = max($maxy, $y);
        $xvel += 0 <=> $xvel;
        $yvel -= 1;

        my $xInRange = $x >= $xlower && $x <= $xupper;
        my $yInRange = $y >= $ylower && $y <= $yupper;
        return $maxy if $xInRange && $yInRange;
        return -1 if !$xInRange && $xvel == 0;
        return -1 if $yvel < 0 && $y < $ylower;
    }
}

my $result = 0;

for my $xvel (1 .. abs $xupper * 2) {
    for my $yvel (1 .. abs $yupper * 2) {
        my $maxy = testvels($xvel, $yvel);
        $result = max($result, $maxy);
    }
}

say $result;