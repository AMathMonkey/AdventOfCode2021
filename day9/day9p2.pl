use warnings;
use Data::Dumper;
use v5.30.0;
use PDL;
use PDL::NiceSlice;
use PDL::AutoLoader;

$PDL::whichND = 's';

my $inputfile = IO::File->new('./input.txt');

my @input = <$inputfile>;
chomp @input;

my $grid = pdl map {[split '', $_]} @input;
my $g = copy $grid;

$grid->where($grid == 0) .= -1;

$grid = $grid->range(ndcoords($grid) - 1, 3, 'truncate');

$grid->where($grid == 0) .= 9;
$grid->where($grid == -1) .= 0;

my ($rows, $cols, $subrows, $subcols) = dims $grid;

my $lowpoints = zeroes $rows, $cols;

for (my $i = 0; $i < $rows; ++$i) {
	for (my $j = 0; $j < $cols; ++$j) {
		my $min = 9;
		for (my $gi = 0; $gi < $subrows; ++$gi) {
			for (my $gj = 0; $gj < $subcols; ++$gj) {
				my $elem = $grid(($i), ($j), ($gi), ($gj));
				$min = $elem if $elem < $min
			}
		}
		my $middle = $grid(($i), ($j), (1), (1));
		$lowpoints($i, $j) .= 1 if $middle == $min;
	}
}

my $basinID = 2;
foreach my $pair (unpdl(whichND $lowpoints == 1)->@*) {
	my ($i, $j) = $pair->@*;

	$lowpoints($i, $j) .= $basinID;

	my $oldlowpoints;
	until (all $oldlowpoints == $lowpoints) {
		$oldlowpoints = copy $lowpoints;
		foreach my $pair (unpdl(whichND $lowpoints == $basinID)->@*) {
			my ($i, $j) = $pair->@*;

			my $curval = sclr $g($i, $j);

			if ($i > 0 && sclr($g($i - 1, $j)) > $curval && sclr($g($i - 1, $j)) < 9) {
				$lowpoints($i - 1, $j) .= $basinID;
			}
			if ($i < $rows - 1 && sclr($g($i + 1, $j)) > $curval && sclr($g($i + 1, $j)) < 9) {
				$lowpoints($i + 1, $j) .= $basinID;
			}
			if ($j > 0 && sclr($g($i, $j - 1)) > $curval && sclr($g($i, $j - 1)) < 9) {
				$lowpoints($i, $j - 1) .= $basinID;
			}
			if ($j < $cols - 1 && sclr($g($i, $j + 1)) > $curval && sclr($g($i, $j + 1)) < 9) {
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