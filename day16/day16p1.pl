use strict;
use warnings;
use Data::Dumper;
use v5.30.0;
use Sub::Recursive;

my $inputfile = IO::File->new('./input.txt');

my $input = <$inputfile>;
chomp $input;

my @hex = split '', $input;

my @bits;

my $versionSum = 0;

while (defined (my $hex = shift @hex)) {
    push @bits, split '', sprintf('%04b', hex $hex)
}

my $parse = recursive {
    my $limitType = shift;
    my $limit = shift;

    my $bitsParsed = 0;
    my $packetsParsed = 0;

    while (@bits > 6) {
        my $cond1 = (defined($limitType) && $limitType == 0) ? $bitsParsed < $limit : 1;
        my $cond2 = (defined($limitType) && $limitType == 1) ? $packetsParsed < $limit : 1;
        last unless $cond1 && $cond2;

        my $version = oct '0b' . join '', splice @bits, 0, 3;
        $bitsParsed += 3;

        say "Version: $version";

        $versionSum += $version;

        my $typeID = oct '0b' . join '', splice @bits, 0, 3;
        $bitsParsed += 3;

        say "TypeID: $typeID";

        if ($typeID == 4) {
            my $flag = 1;
            my $number = '';
            while ($flag) {
                $flag = shift @bits;
                $number .= join '', splice @bits, 0, 4;
                $bitsParsed += 5;
            }
            $number = oct '0b' . $number;
            say "Number: $number\n";
        } else {
            my $lengthTypeID = shift @bits;
            $bitsParsed += 1;

            say "LengthTypeID: $lengthTypeID";

            if ($lengthTypeID == 0) {
                my $lengthOfAllSubpackets = oct '0b' . join '', splice @bits, 0, 15;
                $bitsParsed += 15;
                say "Limit: $lengthOfAllSubpackets bits\n";
                $bitsParsed += $REC->(0, $lengthOfAllSubpackets);
            } else {
                my $numSubpackets = oct '0b' . join '', splice @bits, 0, 11;
                $bitsParsed += 11;
                say "Limit: $numSubpackets packets\n";
                $bitsParsed += $REC->(1, $numSubpackets)
            }
        }
    } continue {++$packetsParsed}
    say "Recursion path ended\n";
    $bitsParsed
};

$parse->();
say $versionSum;