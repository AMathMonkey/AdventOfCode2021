use strict;
use warnings;
use Data::Dumper;
use v5.30.0;
use List::Util qw(any all);

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
    foreach my $beacon1 (@$scanner1) {
        foreach my $beacon2 (@$scanner2) {
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

my @solved = (0);
my %resultSet;
foreach my $beacon ($scanners[0]->@*) {
    $resultSet{beaconRepr($beacon)} = undef
}

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
                foreach my $beacon ($scanners[$j]->@*) {
                    $resultSet{beaconRepr($beacon)} = undef
                }
                next SCANNER
            }
        }
    }
}

say scalar keys %resultSet;
