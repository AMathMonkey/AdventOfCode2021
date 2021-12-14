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

my %counts;
for (my $i = 0; $i < @list - 1; ++$i) {
    $counts{$list[$i] . $list[$i + 1]}++;
}

for (1 .. 40) {
    my %newCounts;
    foreach my $pair (keys %counts) {
        my $rule = $rules{$pair};
        if (defined $rule) {
            my ($char1, $char2) = split '', $pair;
            $newCounts{$char1 . $rule} += $counts{$pair};
            $newCounts{$rule . $char2} += $counts{$pair}
        } else {
            $newCounts{$pair} += $counts{$pair}
        }
    }
    %counts = %newCounts;
}

my %charCounts;
foreach my $pair (keys %counts) {
    my ($char1, $char2) = split '', $pair;
    $charCounts{$char1} += $counts{$pair};
    $charCounts{$char2} += $counts{$pair};
}

foreach my $char (keys %charCounts) {
    $charCounts{$char} = int(($charCounts{$char} + 1) / 2)
}

my $minCount = min values %charCounts;
my $maxCount = max values %charCounts;

say $maxCount - $minCount