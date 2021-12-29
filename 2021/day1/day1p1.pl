use strict;
use warnings;
use v5.28.1;

my $input = IO::File->new('./input.txt');

my $lastval;
my $result = 0;

while ( defined(my $line = <$input>) ) {
    chomp $line;
    ++$result if defined($lastval) && $line > $lastval;
    $lastval = $line;
}

say $result;
