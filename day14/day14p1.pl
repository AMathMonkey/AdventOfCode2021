use strict;
use warnings;
use Data::Dumper;
use v5.30.0;
use List::Util qw(min max);

my $inputfile = IO::File->new('./input.txt');

my @input = <$inputfile>;
chomp @input;

my $template = shift @input;
shift @input;

my %rules;
foreach my $rule (@input) {
    my ($pair, $insert) = split ' -> ', $rule;
    $rules{$pair} = $insert
}

my @list = split '', $template;
for (1 .. 10) {
    my @newList;
    for (my $i = 0; $i < @list - 1; ++$i) {
        my $toInsert = $rules{$list[$i] . $list[$i + 1]};
        push @newList, $list[$i], $toInsert // ()
    }
    push @newList, $list[-1];

    @list = @newList
}

my %counts;
foreach my $elem (@list) {$counts{$elem}++}

my $minCount = min values %counts;
my $maxCount = max values %counts;

say $maxCount - $minCount