use strict;
use warnings;
use Data::Dumper;
use v5.30.0;
use PDL;
use PDL::NiceSlice;

my $inputfile = IO::File->new('./input.txt');

my $input = <$inputfile>;
chomp $input;

my $crabs = pdl(split ',', $input);

my $positions = transpose sequence(int max $crabs);

my $distances = abs($crabs - $positions);

my ($rows, $cols) = dims $distances;
for (my $i = 0; $i < $rows; ++$i) {
    for (my $j = 0; $j < $cols; ++$j) {
        $distances($i, $j) .= sum sequence(int $distances(($i), ($j)) + 1)
    }
}

print min sumover $distances