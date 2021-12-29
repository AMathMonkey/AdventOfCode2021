use strict;
use warnings;
use Data::Dumper;
use v5.28.1;
use PDL;
use PDL::NiceSlice;

my $inputfile = IO::File->new('./input.txt');

my $input = <$inputfile>;
chomp $input;

my $crabs = pdl(split ',', $input);

my $positions = transpose sequence(int max $crabs);

say min sumover abs($crabs - $positions)