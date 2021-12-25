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
            my ($xOffset, $yOffset, $zOffset) = offsets($beacon1, $beacon2);
            my $matches = beaconsInCommon($scanner1, translate($scanner2, $xOffset, $yOffset, $zOffset));
            return ($xOffset, $yOffset, $zOffset) if $matches >= 12;
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

sub rotate { my ($scanner, $rotNum) = @_; 
    [map {
        my ($x, $y, $z) = @$_;
        if ($rotNum == 0) {[$x, $y, $z]}
        elsif ($rotNum == 1) {[-$x, -$y, $z]}
        elsif ($rotNum == 2) {[-$x, $y, -$z]} 
        elsif ($rotNum == 3) {[$x, -$y, -$z]} 
        elsif ($rotNum == 4) {[-$x, $z, $y]} 
        elsif ($rotNum == 5) {[$x, $z, -$y]} 
        elsif ($rotNum == 6) {[$x, -$z, $y]} 
        elsif ($rotNum == 7) {[-$x, -$z, -$y]} 
        elsif ($rotNum == 8) {[-$y, $x, $z]} 
        elsif ($rotNum == 9) {[$y, -$x, $z]} 
        elsif ($rotNum == 10) {[$y, $x, -$z]} 
        elsif ($rotNum == 11) {[-$y, -$x, -$z]} 
        elsif ($rotNum == 12) {[$y, $z, $x]} 
        elsif ($rotNum == 13) {[-$y, -$z, $x]} 
        elsif ($rotNum == 14) {[-$y, $z, -$x]} 
        elsif ($rotNum == 15) {[$y, -$z, -$x]} 
        elsif ($rotNum == 16) {[$z, $x, $y]} 
        elsif ($rotNum == 17) {[-$z, -$x, $y]} 
        elsif ($rotNum == 18) {[-$z, $x, -$y]} 
        elsif ($rotNum == 19) {[$z, -$x, -$y]} 
        elsif ($rotNum == 20) {[-$z, $y, $x]} 
        elsif ($rotNum == 21) {[$z, -$y, $x]} 
        elsif ($rotNum == 22) {[$z, $y, -$x]} 
        elsif ($rotNum == 23) {[-$z, -$y, -$x]} 
        else {die "$rotNum is not between 0 and 23\n"}
    } $scanner->@*]
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

my %resultSet;
my @scannerAndIndex;
my $scanner = shift @scanners;
my $index = 0;
foreach my $beacon (@$scanner) {
    $resultSet{beaconRepr($beacon)} = undef
}

while (any {defined $_} @scanners) {
    say scalar(grep {defined $_} @scanners), ' scanners left';
    SCANNER: for my $i (0 .. $#scanners) {
        last if all {not defined $_} @scanners;
        next if not defined $scanners[$i];
        for my $rotNum (0 .. 23) {
            my $rotated = rotate($scanners[$i], $rotNum);
            my ($xOffset, $yOffset, $zOffset) = findTranslation($scanner, $rotated);
            if (defined $zOffset) {
                say "scanner $i matches and is at $xOffset, $yOffset, $zOffset";
                my $translated = translate($rotated, $xOffset, $yOffset, $zOffset);
                push @scannerAndIndex, $translated, $i;
                foreach my $beacon (@$translated) {
                    $resultSet{beaconRepr($beacon)} = undef
                }
                next SCANNER
            }
        }
    }
    ($scanner, $index) = splice @scannerAndIndex, $#scannerAndIndex - 1, 2;
    die if not defined $scanner;
    $scanners[$index] = undef;
}

# say for keys %resultSet;
say scalar keys %resultSet;
