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

print min sumover abs($crabs - $positions)