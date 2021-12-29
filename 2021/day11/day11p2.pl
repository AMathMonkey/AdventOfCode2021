use strict;
use warnings;
use Data::Dumper;
use PDL;
use PDL::NiceSlice;
use v5.28.1;

my $inputfile = IO::File->new('./input.txt');

my @input = <$inputfile>;
chomp @input;

my $result = 0;

my $grid = pdl long, map {[split '', $_]} @input;

for (my $i = 1; 1; ++$i) {
    $grid += 1;
    my $oldGrid = zeroes dims $grid;
    until (all $grid == $oldGrid) {
        my $previousFlashes = $oldGrid > 9;
        my $previousAndCurrentFlashes = $grid > 9;
        do {say $i; exit} if all $previousAndCurrentFlashes;
        $oldGrid = copy $grid;
        my $currentFlashes = $previousAndCurrentFlashes - $previousFlashes;
        foreach my $flash (whichND($currentFlashes)->unpdl->@*) {
            $grid += (rvals $grid, {Centre => $flash}) == 1
        }
    }
    $grid->where($grid > 9) .= 0;
}