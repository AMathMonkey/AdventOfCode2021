use strict;
use warnings;
use v5.30.0;

my $input = IO::File->new('./input.txt');

my @input = <$input>;
chomp @input;

my @oxygen = @input;
my @co2 = @input;

my $i = 0;
while (@oxygen > 1) {
    @oxygen = grep {
        my @sums;
        foreach (@oxygen) {
            for (my $j = 0; $j < length($_); ++$j) {
                $sums[$j] += substr $_, $j, 1
            }
        }

        my @most_common = map {
            my $times2 = $_ * 2;
            $times2 > @oxygen ? 1 :
            $times2 < @oxygen ? 0 : '='
        } @sums;

        my $most_common = $most_common[$i];
        my $substr = substr($_, $i, 1); 
        $most_common eq '=' ? $substr eq 1 :
        $substr eq $most_common ? 1 : 0
    } @oxygen;

    ++$i;
}

$i = 0;
while (@co2 > 1) {
    @co2 = grep {
        my @sums;
        foreach (@co2) {
            for (my $j = 0; $j < length($_); ++$j) {
                $sums[$j] += substr $_, $j, 1
            }
        }

        my @most_common = map {
            my $times2 = $_ * 2;
            $times2 > @co2 ? 1 :
            $times2 < @co2 ? 0 : '='
        } @sums;

        my $most_common = $most_common[$i];
        my $substr = substr($_, $i, 1); 
        $most_common eq '=' ? $substr eq 0 :
        $substr ne $most_common ? 1 : 0
    } @co2;

    ++$i;
}

my $oxygen = oct '0b' . $oxygen[0];
my $co2 = oct '0b' . $co2[0];

say $oxygen;
say $co2;

say $oxygen * $co2;

