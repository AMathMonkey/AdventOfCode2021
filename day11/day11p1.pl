use strict;
use warnings;
use Data::Dumper;
use PDL;
use PDL::NiceSlice;
use v5.30.0;

my $inputfile = IO::File->new('./input.txt');

my @input = <$inputfile>;
chomp @input;

my $result = 0;

my $grid = pdl long, map {[split '', $_]} @input;

for (1 .. 100) {
    $grid += 1;
    my $oldGrid = zeroes dims $grid;
    until (all $grid == $oldGrid) {
        my $previousFlashes = $oldGrid > 9;
        $oldGrid = copy $grid;
        foreach my $flash (whichND(($grid > 9) - $previousFlashes)->unpdl->@*) {
            $grid += (rvals $grid, {Centre => $flash}) == 1
        }
    }
    my $cellsFlashed = $grid > 9;
    $result += sum $cellsFlashed;
    $grid->where($cellsFlashed) .= 0;
}

say $result;