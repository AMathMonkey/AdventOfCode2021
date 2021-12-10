use strict;
use warnings;
use Data::Dumper;
use v5.30.0;

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
    ')' => 1,
    ']' => 2,
    '}' => 3,
    '>' => 4 
);

my @stacks;

LINE: foreach my $line (@input) {
    my @stack;
    foreach my $char (split '', $line) {
        if ('{([<' =~ /\Q$char/) {push @stack, $char}
        else {
            my $last = pop @stack;
            next LINE if $pairs{$last} ne $char
        }
    }
    push @stacks, \@stack
} 

my @scores;

foreach my $stack (@stacks) {
    my $score = 0;
    foreach my $char (reverse $stack->@*) {
        $score *= 5;
        $score += $values{$pairs{$char}}
    }
    push @scores, $score
} 

say((sort {$a <=> $b} @scores)[int(@scores / 2)])