use strict;
use warnings;
use Data::Dumper;
use v5.28.1;
use PDL;
use PDL::NiceSlice;

$PDL::whichND = 's';

my $inputfile = IO::File->new('./input.txt');

my @input = <$inputfile>;
chomp @input;

my $grid = pdl map {[split '', $_]} @input;
my $g = $grid->copy;

$grid->where($grid == 0) .= -1;

$grid = $grid->range(ndcoords($grid) - 1, 3, 'truncate')->reorder(2,3,0,1);

$grid->where($grid == 0) .= 9;
$grid->where($grid == -1) .= 0;

my ($rows, $cols) = (dims $grid)[2..3];

my $lowpoints = zeroes($rows, $cols);

my $mins = minimum minimum $grid;
$lowpoints->where($mins == $g) .= 1;

my $basinID = 2;
foreach my $pair (whichND($lowpoints == 1)->unpdl->@*) {
	my ($i, $j) = $pair->@*;

	$lowpoints($i, $j) .= $basinID;

	my $oldlowpoints = 0; # placeholder value that will fail comparison first time
	until (all $oldlowpoints == $lowpoints) {
		$oldlowpoints = $lowpoints->copy;
		foreach my $pair (whichND($lowpoints == $basinID)->unpdl->@*) {
			my ($i, $j) = $pair->@*;

			my $curval = $g($i, $j)->sclr;

			if ($i > 0 && $g($i - 1, $j)->sclr > $curval && $g($i - 1, $j)->sclr < 9) {
				$lowpoints($i - 1, $j) .= $basinID;
			}
			if ($i < $rows - 1 && $g($i + 1, $j)->sclr > $curval && $g($i + 1, $j)->sclr < 9) {
				$lowpoints($i + 1, $j) .= $basinID;
			}
			if ($j > 0 && $g($i, $j - 1)->sclr > $curval && $g($i, $j - 1)->sclr < 9) {
				$lowpoints($i, $j - 1) .= $basinID;
			}
			if ($j < $cols - 1 && $g($i, $j + 1)->sclr > $curval && $g($i, $j + 1)->sclr < 9) {
				$lowpoints($i, $j + 1) .= $basinID;
			}
		}
	}
} continue {
	++$basinID
}

my @sizes;
for (2 .. $basinID - 1) {
    push @sizes, sclr sum $lowpoints == $_
}

@sizes = reverse sort {$a <=> $b} @sizes;

say $sizes[0] * $sizes[1] * $sizes[2];