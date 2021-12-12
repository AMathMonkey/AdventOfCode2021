use strict;
use warnings;
use Data::Dumper;
use v5.30.0;

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

my %pathStrings;

sub recursive {
    my $current = shift;
    my %traversed = shift->%*;
    my $twoAllowed = shift;
    my $pathString = shift;

    if ($current eq 'end') {
        $pathStrings{$pathString} = undef if $pathString;
        return
    };

    foreach my $node (keys $connections{$current}->%*) {
        my $timesNodeTraversed = $traversed{$node} // 0;
        
        recursive($node, {%traversed, $node => $timesNodeTraversed + 1}, $twoAllowed, $pathString . '-' . $node)
            unless $node eq 'start' ||
                $node ne 'end' && isLower($node) && $timesNodeTraversed >= 1 && $node ne $twoAllowed ||
                $node eq $twoAllowed && $timesNodeTraversed >= 2;
    }
}

foreach my $twoAllowed (grep {isLower($_) && $_ ne 'start' && $_ ne 'end'} keys %connections) {
    recursive('start', {'start' => 1}, $twoAllowed, 'start')
}

say scalar keys %pathStrings