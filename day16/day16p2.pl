use strict;
use warnings;
use Data::Dumper;
use v5.30.0;
use List::Util qw(min max product sum);
use bigint;

my $inputfile = IO::File->new('./input.txt');

my $input = <$inputfile>;
chomp $input;

my @hex = split '', $input;
my @bits;
while (defined(my $hex = shift @hex)) {
    push @bits, split '', sprintf('%04b', hex $hex)
}

sub applyOp { my ($op, @numbers) = @_;
    if ($op == 0) {
        sum @numbers
    } elsif ($op eq 1) {
        product @numbers
    } elsif ($op eq 2) {
        min @numbers
    } elsif ($op eq 3) {
        max @numbers
    } elsif ($op eq 5) {
        ($numbers[0] > $numbers[1]) || 0
    } elsif ($op eq 6) {
        ($numbers[0] < $numbers[1]) || 0
    } elsif ($op eq 7) {
        ($numbers[0] == $numbers[1]) || 0
    }
}

sub parse { my $packet = shift;

    my $version = oct '0b' . join '', splice @$packet, 0, 3;
    my $typeID = oct '0b' . join '', splice @$packet, 0, 3;

    if ($typeID == 4) {
        my $flag = 1;
        my $number = '';
        while ($flag) {
            $flag = shift @$packet;
            $number .= join '', splice @$packet, 0, 4
        }
        $number = oct '0b' . $number;
        return $number
    } else {
        my $lengthTypeID = shift @$packet;
        my @numbers;
        if ($lengthTypeID == 0) {
            my $lengthOfAllSubpackets = oct '0b' . join '', splice @$packet, 0, 15;
            my @subpackets = splice @$packet, 0, $lengthOfAllSubpackets;
            while (@subpackets) {
                push @numbers, parse(\@subpackets)
            }
        } else {
            my $numSubpackets = oct '0b' . join '', splice @$packet, 0, 11;
            for (1 .. $numSubpackets) {
                push @numbers, parse($packet)
            }
        }
        return applyOp($typeID, @numbers)
    }
};

say parse(\@bits);
