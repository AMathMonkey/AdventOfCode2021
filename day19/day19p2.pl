use strict;
use warnings;
use Data::Dumper;
use v5.28.1;
use List::Util qw(any all max);

my $inputfile = IO::File->new('./input.txt');

chomp(my @input = <$inputfile>);
push @input, '';

my @scanners;
my @scanner;
foreach my $line (@input) {
    if (not $line) {push @scanners, [@scanner]}
    elsif ($line =~ /---/) {@scanner = ()}
    else {
        my ($x, $y, $z) = split ',', $line;
        push @scanner, [$x, $y, $z]
    }
}

sub findTranslation { my ($scanner1, $scanner2) = @_;
    foreach my $beacon1 ($scanner1->@[0 .. $#$scanner1 - 11]) {
        foreach my $beacon2 ($scanner2->@[0 .. $#$scanner2 - 11]) {
            my @offsets = offsets($beacon1, $beacon2);
            my $matches = beaconsInCommon($scanner1, translate($scanner2, @offsets));
            return @offsets if $matches >= 12;
        }
    }
    ()
}

sub translate { my ($scanner, $tx, $ty, $tz) = @_;
    [map {
        my ($x, $y, $z) = @$_;
        [$x + $tx, $y + $ty, $z + $tz]
    } @$scanner]
}

my @rotNumToRotator = (
    sub {my ($x, $y, $z) = @_; [$x, $y, $z]},
    sub {my ($x, $y, $z) = @_; [-$x, -$y, $z]},
    sub {my ($x, $y, $z) = @_; [-$x, $y, -$z]}, 
    sub {my ($x, $y, $z) = @_; [$x, -$y, -$z]},
    sub {my ($x, $y, $z) = @_; [-$x, $z, $y]},
    sub {my ($x, $y, $z) = @_; [$x, $z, -$y]},
    sub {my ($x, $y, $z) = @_; [$x, -$z, $y]},
    sub {my ($x, $y, $z) = @_; [-$x, -$z, -$y]},
    sub {my ($x, $y, $z) = @_; [-$y, $x, $z]},
    sub {my ($x, $y, $z) = @_; [$y, -$x, $z]},
    sub {my ($x, $y, $z) = @_; [$y, $x, -$z]},
    sub {my ($x, $y, $z) = @_; [-$y, -$x, -$z]},
    sub {my ($x, $y, $z) = @_; [$y, $z, $x]},
    sub {my ($x, $y, $z) = @_; [-$y, -$z, $x]},
    sub {my ($x, $y, $z) = @_; [-$y, $z, -$x]},
    sub {my ($x, $y, $z) = @_; [$y, -$z, -$x]},
    sub {my ($x, $y, $z) = @_; [$z, $x, $y]},
    sub {my ($x, $y, $z) = @_; [-$z, -$x, $y]},
    sub {my ($x, $y, $z) = @_; [-$z, $x, -$y]},
    sub {my ($x, $y, $z) = @_; [$z, -$x, -$y]},
    sub {my ($x, $y, $z) = @_; [-$z, $y, $x]},
    sub {my ($x, $y, $z) = @_; [$z, -$y, $x]},
    sub {my ($x, $y, $z) = @_; [$z, $y, -$x]},
    sub {my ($x, $y, $z) = @_; [-$z, -$y, -$x]}
);

sub rotate { my ($scanner, $rotNum) = @_; 
    [map {$rotNumToRotator[$rotNum]->(@$_)} @$scanner]
}

sub beaconRepr { my ($beacon) = @_;
    join ',', @$beacon
}

sub offsets { my ($beacon1, $beacon2) = @_;
    my ($x1, $y1, $z1) = @$beacon1;
    my ($x2, $y2, $z2) = @$beacon2;
    ($x1 - $x2, $y1 - $y2, $z1 - $z2)
}

sub beaconsEqual { my ($beacon1, $beacon2) = @_;
    beaconRepr($beacon1) eq beaconRepr($beacon2)
}

sub beaconsInCommon { my ($scanner1, $scanner2) = @_;
    scalar grep {
        my $beacon = $_; 
        any {beaconsEqual($beacon, $_)} @$scanner2
    } @$scanner1
} 

sub manhattan { my ($pos1, $pos2) = @_;
    my ($x1, $y1, $z1) = split ',', $pos1;
    my ($x2, $y2, $z2) = split ',', $pos2;
    abs($x1 - $x2) + abs($y1 - $y2) + abs($z1 - $z2)
}

my @solved = (0);
my %resultSet = ("0,0,0" => undef);

foreach my $i (@solved) {
    say @scanners - @solved, ' scanners left';
    SCANNER: for my $j (0 .. $#scanners) {
        next if $i == $j || any {$_ == $j} @solved;
        for my $rotNum (0 .. 23) {
            my $rotated = rotate($scanners[$j], $rotNum);
            my ($xOffset, $yOffset, $zOffset) = findTranslation($scanners[$i], $rotated);
            if (defined $zOffset) {
                say "scanner $i overlaps with scanner $j and the latter is at $xOffset, $yOffset, $zOffset";
                $scanners[$j] = translate($rotated, $xOffset, $yOffset, $zOffset);
                push @solved, $j;
                $resultSet{"$xOffset,$yOffset,$zOffset"} = undef;
                next SCANNER
            }
        }
    }
}

my @scannerPositions = keys %resultSet;
my $result = 0;

for my $i (0 .. $#scannerPositions) {
    for my $j ($i + 1 .. $#scannerPositions) {
        next if $i == $j;
        $result = max $result, manhattan($scannerPositions[$i], $scannerPositions[$j])
    }
}

say $result;
