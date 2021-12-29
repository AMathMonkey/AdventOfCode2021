use strict;
use warnings;
use Data::Dumper;
use v5.28.1;

my $inputfile = IO::File->new('./input.txt');

my @input = <$inputfile>;
chomp @input;

sub isLower {
    $_[0] eq lc($_[0])
}

my %connections;

foreach my $line (@input) {
    my ($start, $end) = split '-', $line;
    $connections{$start} = {($connections{$start} // {})->%*, $end => undef};
    $connections{$end} = {($connections{$end} // {})->%*, $start => undef}
}

sub recursive {
    my $current = shift;
    my %traversed = shift->%*;

    return 1 if $current eq 'end';

    my $pathsFromHere = 0;
    foreach my $node (keys $connections{$current}->%*) {
        unless (isLower($node) && exists $traversed{$node}) {
            $pathsFromHere += recursive($node, {%traversed, $node => undef})
        }
    }
    $pathsFromHere
}

say recursive('start', {'start' => undef})