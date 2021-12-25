use strict;
use warnings;
use Data::Dumper;
use v5.30.0;
use PDL;
use PDL::NiceSlice;

my $inputfile = IO::File->new('./input.txt');

chomp(my @input = <$inputfile>);

my $alg = do {
    my $algstr = shift @input;
    $algstr =~ tr/.#/01/;
    pdl split '', $algstr;
};

shift @input;

my $image = do {
    my @image;
    while (@input) {
        my $str = shift @input;
        $str =~ tr/.#/01/;
        push @image, [split '', $str];
    }
    pdl @image
};

# say $image;
my $padding = 0;

for (1 .. 2) {
    # if any of the first row or col or last row or call are 1, add padding all around
    if (any $image(0, :) and any $image(:, 0) and any $image(-1, :) and any $image(:, -1)) {
        my ($rows, $cols) = dims $image;
        my $r = $padding ? ones($rows) : zeroes($rows);
        my $c = ($padding ? ones($cols + 2) : zeroes($cols + 2))->transpose;
        $image = $r->glue(1, $image, $r);
        $image = $c->glue(0, $image, $c);
    }

    my ($rows, $cols) = dims $image;
    my $newImage = zeroes dims $image;
    for my $i (0 .. $rows - 1) {
        for my $j (0 .. $cols - 1) {
            my $imincond = $i > 0;
            my $imaxcond = $i < $rows - 1;
            my $jmincond = $j > 0;
            my $jmaxcond = $j < $cols - 1;

            my @nums = (
                ($imincond && $jmincond) ? $image($i - 1, $j - 1)->sclr : $padding,
                ($jmincond) ? $image($i, $j - 1)->sclr : $padding,
                ($imaxcond && $jmincond) ? $image($i + 1, $j - 1)->sclr : $padding,
                ($imincond) ? $image($i - 1, $j)->sclr : $padding,
                $image($i, $j)->sclr,
                ($imaxcond) ? $image($i + 1, $j)->sclr : $padding,
                ($imincond && $jmaxcond) ? $image($i - 1, $j + 1)->sclr : $padding,
                ($jmaxcond) ? $image($i, $j + 1)->sclr : $padding,
                ($imaxcond && $jmaxcond) ? $image($i + 1, $j + 1)->sclr : $padding,
            );
            my $binindex = join '', @nums;
            my $index = oct "0b$binindex";
            $newImage($i, $j) .= $alg($index)->sclr;
        }
    }
    $image = copy $newImage;
    $padding = $padding ? 0 : 1
}

say sum $image;