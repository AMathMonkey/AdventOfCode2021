use strict;
use warnings;
use Data::Dumper;
use v5.28.1;
use PDL;
use PDL::NiceSlice;

my $inputfile = IO::File->new('./input.txt');

chomp(my @input = <$inputfile>);

my $grid = zeroes byte, 101, 101, 101;

LINE: foreach my $line (@input) {
    my ($command, $xmin, $xmax, $ymin, $ymax, $zmin, $zmax) = 
        $line =~ /(on|off) x=(-?\d+)\.\.(-?\d+),y=(-?\d+)\.\.(-?\d+),z=(-?\d+)\.\.(-?\d+)/;

    foreach ($xmin, $xmax, $ymin, $ymax, $zmin, $zmax) {
        next LINE if $_ < -50 or $_ > 50;
        $_ += 50
    }

    $grid($xmin:$xmax, $ymin:$ymax, $zmin:$zmax) .= ($command eq 'on') ? 1 : 0;
}

say sum $grid;