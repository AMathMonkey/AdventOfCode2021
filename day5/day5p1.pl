use strict;
use warnings;
use Data::Dumper;
use v5.30.0;
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

    next unless ($startx == $endx || $starty == $endy);

    if ($startx == $endx) {
        $grid->($startx, $starty:$endy) += 1
    } else {
        $grid->($startx:$endx, $starty) += 1
    }
}

print sum($grid > 1)