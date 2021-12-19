use strict;
use warnings;
use Data::Dumper;
use v5.30.0;
use POSIX qw(floor ceil);
use List::Util qw(max);

my $inputfile = IO::File->new('./input.txt');

chomp(my @input = <$inputfile>);

sub leftRight { my ($pair) = @_;
    $pair =~ s/^\[(.+)\]$/$1/; # remove outer square brackets

    my $splitIndex = do {
        my $result;
        my $openBrackets = 0;
        for my $i (0 .. length($pair) - 1) {
            my $char = substr($pair, $i, 1);
            ++$openBrackets if $char eq '[';
            --$openBrackets if $char eq ']';
            do {$result = $i; last} if $openBrackets == 0 && $char eq ','
        }
        $result // die "Finding the index of the comma not in brackets didn't work"
    };
    (substr($pair, 0, $splitIndex), substr($pair, $splitIndex + 1))
}

sub explodeIfNeeded { my ($pair) = @_;
    my ($startRange, $endRange);
    my $openBrackets = 0;
    for my $i (0 .. length($pair) - 1) {
        my $char = substr($pair, $i, 1);
        ++$openBrackets if $char eq '[';
        --$openBrackets if $char eq ']';

        if ($openBrackets == 5 && !defined($startRange)) {
            $startRange = $i;
        }
        if ($openBrackets == 4 && defined($startRange)) {
            $endRange = $i;
            last
        }
    }
    goto &splitIfNeeded unless defined($startRange) && defined($endRange);

    my ($left, $right) = leftRight(substr($pair, $startRange, $endRange - $startRange + 1));

    my ($leftStartRange, $leftEndRange);
    for (my $i = $startRange - 1; $i >= 0; --$i) {
        my $char = substr($pair, $i, 1);
        if ($char =~ /\d/ && !defined($leftEndRange)) {
            $leftEndRange = $i;
        }
        if ($char !~ /\d/ && defined($leftEndRange)) {
            $leftStartRange = $i + 1;
            last
        }
    }

    if (defined($leftStartRange) && defined($leftEndRange)) {
        my $num = substr($pair, $leftStartRange, $leftEndRange - $leftStartRange + 1);
        my $len = length $num;
        $num += $left;
        my $sizeDiff = length($num) - $len;
        substr($pair, $leftStartRange, $leftEndRange - $leftStartRange + 1) = $num;
        $startRange += $sizeDiff;
        $endRange += $sizeDiff
    }

    my ($rightStartRange, $rightEndRange);
    for (my $i = $endRange + 1; $i < length($pair); ++$i) {
        my $char = substr($pair, $i, 1);
        if ($char =~ /\d/ && !defined($rightStartRange)) {
            $rightStartRange = $i;
        }
        if ($char !~ /\d/ && defined($rightStartRange)) {
            $rightEndRange = $i - 1;
            last
        }
    }

    if (defined($rightStartRange) && defined($rightEndRange)) {
        substr($pair, $rightStartRange, $rightEndRange - $rightStartRange + 1) += $right
    }

    substr($pair, $startRange, $endRange - $startRange + 1) = '0';

    @_ = ($pair); goto &explodeIfNeeded
}

sub splitIfNeeded { my ($pair) = @_;
    if ($pair =~ /\d{2,}/) {
        my $div = substr($pair, $-[0], $+[0] - $-[0]) / 2;
        substr($pair, $-[0], $+[0] - $-[0]) = '[' . floor($div) . ',' . ceil($div) . ']';
        
        @_ = ($pair); goto &explodeIfNeeded
    }
    $pair
}

sub add { my ($pair1, $pair2) = @_;
    explodeIfNeeded("[$pair1,$pair2]")
}

sub magnitude { my ($pair) = @_;
    my $result = 0;

    my ($left, $right) = leftRight($pair);

    my $leftIsRegularNumber = $left !~ /\[/;
    my $rightIsRegularNumber = $right !~ /\[/;

    if ($leftIsRegularNumber) {$result += $left * 3}
    else {$result += 3 * magnitude($left)}
    if ($rightIsRegularNumber) {$result += $right * 2}
    else {$result += 2 * magnitude($right)}

    $result
}

my $result = 0;

for my $i (0 .. $#input) {
    for my $j (0 .. $#input) {
        next if $i == $j;
        $result = max $result, magnitude(add($input[$i], $input[$j]))
    }
}

say $result;