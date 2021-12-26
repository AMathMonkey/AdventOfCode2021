use strict;
use warnings;
use v5.28.1;

my $input = IO::File->new('./input.txt');

my $numlines = 0;
my @sums;

while (defined(my $line = <$input>)) {
    chomp $line;

    for (my $i = 0; $i < length($line); ++$i) {
        $sums[$i] += substr $line, $i, 1
    }

    ++$numlines;
}

print "$_ " for @sums;
say '';

my @gamma = map {$_ > $numlines / 2 ? 1 : 0} @sums;
my @epsilon = map {$_ == 1 ? 0 : 1} @gamma;

print "$_ " for @gamma;
say '';

print "$_ " for @epsilon;
say '';


my $gamma = join '', @gamma;
my $epsilon = join '', @epsilon;

$gamma = oct '0b' . $gamma;
$epsilon = oct '0b' . $epsilon;

say $gamma * $epsilon;

