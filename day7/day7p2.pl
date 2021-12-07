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

print min sumover ($distances * ($distances + 1) / 2);