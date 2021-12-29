use strict;
use warnings;
use Data::Dumper;
use v5.28.1;
use PDL;
use PDL::NiceSlice;

my $input = IO::File->new('./input.txt');

my @input = <$input>;
chomp @input;

my @points;

foreach my $line (@input) {
    my ($pair1, $pair2) = split ' -> ', $line;
    push @points, split ',', $pair1;
    push @points, split ',', $pair2;
}

sub getdims {
    my @pointstemp = @_;
    my ($maxx, $maxy);
    while (@pointstemp) {
        my $startx = shift @pointstemp;
        my $starty = shift @pointstemp;
        my $endx = shift @pointstemp;
        my $endy = shift @pointstemp;

        $maxx = List::Util::max ($startx, $endx, $maxx // 0);
        $maxy = List::Util::max ($starty, $endy, $maxy // 0);
    }
    ($maxx, $maxy)
}

my ($maxx, $maxy) = getdims @points;

my $grid = zeroes $maxx + 1, $maxy + 1;

while (@points) {
    my $startx = shift @points;
    my $starty = shift @points;
    my $endx = shift @points;
    my $endy = shift @points;

    if ($startx == $endx) {
        $grid($startx, $starty:$endy) += 1
    } elsif ($starty == $endy) {
        $grid($startx:$endx, $starty) += 1
    } else {
        my $i = $startx;
        my $j = $starty;
        while (1) {
            $grid->($i, $j) += 1;
            if ($startx <= $endx) {++$i} else {--$i}
            if ($starty <= $endy) {++$j} else {--$j}
            if ($startx <= $endx) {
                last if $i > $endx
            } else {
                last if $i < $endx
            }

            if ($starty <= $endy) {
                last if $j > $endy
            } else {
                last if $j < $endy
            }
        }
    }
}

say sum($grid > 1)