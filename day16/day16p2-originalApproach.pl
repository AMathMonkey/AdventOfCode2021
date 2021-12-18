use strict;
use warnings;
use Data::Dumper;
use v5.30.0;
use Sub::Recursive;
use List::Util qw(min max sum product);
use bigint;

my $inputfile = IO::File->new('./input.txt');

chomp(my $input = <$inputfile>);

my @hex = split '', $input;

my @bits;

sub applyOp { my ($op, @numbers) = @_;
    if ($op == 0) {
        sum @numbers
    } elsif ($op == 1) {
        product @numbers
    } elsif ($op == 2) {
        min @numbers
    } elsif ($op == 3) {
        max @numbers
    } elsif ($op == 5) {
        ($numbers[0] > $numbers[1]) || 0
    } elsif ($op == 6) {
        ($numbers[0] < $numbers[1]) || 0
    } elsif ($op == 7) {
        ($numbers[0] == $numbers[1]) || 0
    }
}

while (defined (my $hex = shift @hex)) {
    push @bits, split '', sprintf('%04b', hex $hex)
}

my $parse = recursive {
    my $limitType = shift;
    my $limit = shift;

    my @numbers;

    my $bitsParsed = 0;
    my $packetsParsed = 0;

    while (@bits > 6) {
        my $cond1 = (defined($limitType) && $limitType == 0) ? $bitsParsed < $limit : 1;
        my $cond2 = (defined($limitType) && $limitType == 1) ? $packetsParsed < $limit : 1;
        last unless $cond1 && $cond2;

        my $version = oct '0b' . join '', splice @bits, 0, 3;
        $bitsParsed += 3;

        my $typeID = oct '0b' . join '', splice @bits, 0, 3;
        $bitsParsed += 3;

        if ($typeID == 4) {
            my $flag = 1;
            my $number = '';
            while ($flag) {
                $flag = shift @bits;
                $number .= join '', splice @bits, 0, 4;
                $bitsParsed += 5;
            }
            $number = oct '0b' . $number;
            push @numbers, $number;
        } else {
            my $lengthTypeID = shift @bits;
            $bitsParsed += 1;

            my @recursiveResult;
            if ($lengthTypeID == 0) {
                my $lengthOfAllSubpackets = oct '0b' . join '', splice @bits, 0, 15;
                $bitsParsed += 15;
                @recursiveResult = $REC->(0, $lengthOfAllSubpackets);
            } else {
                my $numSubpackets = oct '0b' . join '', splice @bits, 0, 11;
                $bitsParsed += 11;
                @recursiveResult = $REC->(1, $numSubpackets);
            }
            $bitsParsed += pop @recursiveResult;
            push @numbers, applyOp($typeID, @recursiveResult);
        }
    } continue {++$packetsParsed}
    (@numbers, $bitsParsed)
};

say(($parse->())[0])