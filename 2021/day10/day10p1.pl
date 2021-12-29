use strict;
use warnings;
use Data::Dumper;
use v5.28.1;

my $inputfile = IO::File->new('./input.txt');

my @input = <$inputfile>;
chomp @input;

my %pairs = (
    '{' => '}',
    '(' => ')',
    '[' => ']',
    '<' => '>'
);

my %values = (
    ')' => 3,
    ']' => 57,
    '}' => 1197,
    '>' => 25137 
);

my $score = 0;

LINE: foreach my $line (@input) {
    my @stack;
    foreach my $char (split '', $line) {
        if ('{([<' =~ /\Q$char/) {push @stack, $char}
        else {
            my $last = pop @stack;
            if ($pairs{$last} ne $char) {
                $score += $values{$char};
                next LINE
            }
        }
    }
} 

say $score;