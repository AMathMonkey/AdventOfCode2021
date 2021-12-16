use strict;
use warnings;
use Data::Dumper;
use v5.30.0;
use PDL;
use PDL::NiceSlice;

my $inputfile = IO::File->new('./input.txt');

my @input = <$inputfile>;
chomp @input;

my $risks = pdl([map {[split '', $_]} @input]);

my ($rows, $cols) = dims $risks;

my $visited = zeroes $rows, $cols;
my $distances = zeroes $rows, $cols;

$distances(:, :) .= 'Inf';
$distances(0, 0) .= 0;

my @current = (0, 0);
while (1) {
    my ($i, $j) = @current;
    my $currentDistance = $distances(@current)->sclr;

    my $calcDistance = sub {
        my ($cond, $i1, $j1) = @_;
        if ($cond && $visited($i1, $j1)->sclr == 0) {
            my $newval = $currentDistance + $risks($i1, $j1)->sclr;
            $distances($i1, $j1) .= $newval if $distances($i1, $j1)->sclr > $newval;
        }
    };

    &{$calcDistance}($i - 1 >= 0, $i - 1, $j);
    &{$calcDistance}($i + 1 < $rows, $i + 1, $j);
    &{$calcDistance}($j - 1 >= 0, $i, $j - 1);
    &{$calcDistance}($j + 1 < $cols, $i, $j + 1);

    $visited($i, $j) .= 1;
    last if $visited($rows - 1, $cols - 1)->sclr == 1;

    my $unvisitedDistances = $distances->where($visited == 0);
    my $minUnvisited = min $unvisitedDistances;
    @current = whichND(($distances == $minUnvisited) & ($visited == 0))->unpdl->[0]->@*;
}

say $distances($rows - 1, $cols - 1)->sclr;