use strict;
use warnings;
use Data::Dumper;
use v5.28.1;
use PDL;
use PDL::NiceSlice;

my $inputfile = IO::File->new('./input.txt');

my @input = <$inputfile>;
chomp @input;

my $grid = pdl map {[split '', $_]} @input;
my $g = $grid->copy;

$grid->where($grid == 0) .= -1;

$grid = $grid->range(ndcoords($grid) - 1, 3, 'truncate')->reorder(2,3,0,1);

$grid->where($grid == 0) .= 9;
$grid->where($grid == -1) .= 0;

my $mins = minimum minimum $grid;

say sum $mins->where($mins == $g) + 1;