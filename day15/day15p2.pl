use strict;
use warnings;
use Data::Dumper;
use v5.30.0;
use PDL;
use PDL::NiceSlice;
use Heap::MinMax;

my $heap = Heap::MinMax->new(
    fcompare => sub { my ($s1, $s2) = @_;
        $s1->[2] <=> $s2->[2]
    }
);

my $inputfile = IO::File->new('./input.txt');

my @input = <$inputfile>;
chomp @input;

my $risks = pdl([map {[split '', $_]} @input]);
my $orig = copy $risks;

for (1 .. 4) {
    my $newTile = $orig + $_;
    $newTile->where($newTile > 9) -= 9;
    $risks = $risks->append($newTile);
}

my $rect = copy $risks;

for (1 .. 4) {
    my $newTile = $rect + $_;
    $newTile->where($newTile > 9) -= 9;
    $risks = $risks->glue(1, $newTile);
}

my ($rows, $cols) = dims $risks;

my $visited = zeroes $rows, $cols;
my $distances = zeroes $rows, $cols;

$distances(:, :) .= 'Inf';
$distances(0, 0) .= 0;

my @current = (0, 0);
while (1) {
    my ($i, $j) = @current;
    my $currentDistance = $distances(@current)->sclr;

    my $calcDistance = sub { my ($cond, $i1, $j1) = @_;
        if ($cond && $visited($i1, $j1)->sclr == 0) {
            my $newval = $currentDistance + $risks($i1, $j1)->sclr;
            if ($distances($i1, $j1)->sclr > $newval) {
                $distances($i1, $j1) .= $newval;
                $heap->insert([$i1, $j1, $newval])
            };
        }
    };

    &{$calcDistance}($i - 1 >= 0, $i - 1, $j);
    &{$calcDistance}($i + 1 < $rows, $i + 1, $j);
    &{$calcDistance}($j - 1 >= 0, $i, $j - 1);
    &{$calcDistance}($j + 1 < $cols, $i, $j + 1);

    $visited($i, $j) .= 1;
    last if $visited($rows - 1, $cols - 1)->sclr == 1;

    my ($mini, $minj, $min);
    do {
        ($mini, $minj, $min) = $heap->pop_min->@*;
    } while ($visited($mini, $minj)->sclr == 1);

    @current = ($mini, $minj)
}

say $distances($rows - 1, $cols - 1)->sclr;