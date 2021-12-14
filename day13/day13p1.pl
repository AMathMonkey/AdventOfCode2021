use strict;
use warnings;
use Data::Dumper;
use v5.30.0;
use List::Util qw(max);
use PDL;
use PDL::NiceSlice;

my $inputfile = IO::File->new('./input.txt');

my @input = <$inputfile>;
chomp @input;

my @points;
my @folds;

foreach my $line (@input) {
    if ($line =~ /(\d+),(\d+)/) {
        push @points, [$1, $2]
    } elsif ($line =~ /fold along (\w)=(\d+)/) {
        push @folds, [$1, $2]
    }
}

my $rows = (List::Util::max map {$_->[0]} @points) + 1;
my $cols = (List::Util::max map {$_->[1]} @points) + 1;

$rows += 1 if $rows % 2 == 0;
$cols += 1 if $cols % 2 == 0;

my $grid = zeroes $rows, $cols;

foreach my $point (@points) {
    $grid($point->[0], $point->[1]) .= 1
}

foreach my $fold (@folds) {
    my $pos = $fold->[1];
    if ($fold->[0] eq 'x') {
        $grid = $grid(0 : $pos-1, :) | $grid(-1 : $pos+1, :);
    } else {
        $grid = $grid(:, 0 : $pos-1) | $grid(:, -1 : $pos+1);
    }
    last;
}

say sum $grid