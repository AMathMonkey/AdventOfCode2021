use warnings;
use Data::Dumper;
use v5.30.0;
use PDL;
use PDL::NiceSlice;
use PDL::AutoLoader;

my $inputfile = IO::File->new('./input.txt');

my @input = <$inputfile>;
chomp @input;

my $grid = pdl map {[split '', $_]} @input;

$grid->whereND($grid == 0) .= -2;

$grid = $grid->range(ndcoords($grid) - 1, 3, 'truncate');

$grid->whereND($grid == 0) .= -1;
$grid->whereND($grid == -2) .= 0;

my ($rows, $cols, $gridrows, $gridcols) = dims $grid;

my $result = zeroes $rows, $cols;

for (my $i = 0; $i < $rows; $i++) {
    for (my $j = 0; $j < $cols; $j++) {
        my $min = 10;
        for (my $gi = 0; $gi < $gridrows; $gi++) {
            for (my $gj = 0; $gj < $gridcols; $gj++) {
                my $elem = $grid(($i), ($j), ($gi), ($gj));
                $min = $elem if $elem < $min && $elem > -1;
            }
        }
        my $middle = $grid(($i), ($j), (1), (1));
        $result($i, $j) .= $middle + 1 if $middle == $min;
    }
}

print sum $result;