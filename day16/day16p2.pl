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

my %ops = (
    0 => '+',
    1 => '*',
    2 => 'min',
    3 => 'max',
    5 => '>',
    6 => '<',
    7 => '=',
);

sub applyOp { my ($op, @numbers) = @_;
    if ($op eq '+') {
        sum @numbers
    } elsif ($op eq '*') {
        product @numbers
    } elsif ($op eq 'min') {
        min @numbers
    } elsif ($op eq 'max') {
        max @numbers
    } elsif ($op eq '>') {
        ($numbers[0] > $numbers[1]) || 0
    } elsif ($op eq '<') {
        ($numbers[0] < $numbers[1]) || 0
    } elsif ($op eq '=') {
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
            return applyOp($ops{$typeID}, @numbers)
        } else {
            my $numSubpackets = oct '0b' . join '', splice @$packet, 0, 11;
            for (1 .. $numSubpackets) {
                push @numbers, parse($packet)
            }
            return applyOp($ops{$typeID}, @numbers)
        }
    }
};

say parse(\@bits);
