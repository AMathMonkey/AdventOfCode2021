use strict;
use warnings;
use Data::Dumper;
use v5.30.0;
use List::Util qw(first);

my $inputfile = IO::File->new('./input.txt');

my @input = <$inputfile>;
chomp @input;

my @patterns;
my @displays;

foreach my $line (@input) {
    my ($digits, $output) = split ' \| ', $line;

    my @digits = split ' ', $digits;
    my @output = split ' ', $output;

    push @patterns, \@digits;
    push @displays, \@output;
}

my $result = 0;

foreach my $row (@displays) {
    foreach my $elem ($row->@*) {
        ++$result if grep {$_ == length $elem} (2, 3, 4, 7);
    }
}

print $result;