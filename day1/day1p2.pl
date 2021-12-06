use strict;
use warnings;
use v5.30.0;
use List::Util qw(sum);

my $input = IO::File->new('./input.txt');

my @list;
my $lastsum;
my $result = 0;

while (defined(my $line = <$input>)) {
    push @list, $line;
    if (@list == 3) {
        my $sum = sum @list;
        ++$result if defined($lastsum) && $sum > $lastsum;
        shift @list;
        $lastsum = $sum;
    }
}

say $result;
