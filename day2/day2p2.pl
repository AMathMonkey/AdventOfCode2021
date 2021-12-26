use strict;
use warnings;
use v5.28.1;

my $input = IO::File->new('./input.txt');

my $horizontal = 0;
my $depth = 0;
my $aim = 0;

while (defined(my $line = <$input>)) {
    chomp $line;
    my ($dir, $num) = split ' ', $line;
    if ($dir eq 'forward') {
        $horizontal += $num;
        $depth += $aim * $num
    }
    elsif ($dir eq 'up') {
        $aim -= $num
    }
    elsif ($dir eq 'down') {
        $aim += $num
    }
}
say $horizontal * $depth;