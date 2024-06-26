use strict;
use warnings;
use Data::Dumper;
use v5.28.1;
use List::Util qw(first sum);

my $inputfile = IO::File->new('./input.txt');

my @input = <$inputfile>;
chomp @input;

my %decoder = (
    'abcefg' => 0,
    'cf' => 1,
    'acdeg' => 2,
    'acdfg' => 3,
    'bcdf' => 4,
    'abdfg' => 5,
    'abdefg' => 6,
    'acf' => 7,
    'abcdefg' => 8,
    'abcdfg' => 9
);

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
for (my $i = 0; $i < @patterns; ++$i) {
    my @row = $patterns[$i]->@*;

	my %segments;
	my $one = first {length == 2} @row;
	my $seven = first {length == 3} @row;
    my $four = first {length == 4} @row;

	$segments{a} = first {$one !~ /$_/} split '', $seven;

    $segments{f} = first {
        my $char = $_;
        (grep {/$char/} @row) == 9
    } ('a' .. 'g');

    $segments{c} = first {
        my $char = $_;
        (grep {/$char/} values %segments) == 0
    } split '', $seven;

    my $two = first {
        $_ =~ /$segments{a}/ && ($_ =~ /$segments{c}/) && ($_ !~ /$segments{f}/)
    } @row;

    my $three = first {
        length == 5 && ($_ =~ /$segments{a}/) && ($_ =~ /$segments{f}/) && ($_ =~ /$segments{c}/)
    } @row;

    my $five = first {
        length == 5 && ($_ =~ /$segments{a}/) && ($_ =~ /$segments{f}/) && ($_ !~ /$segments{c}/)
    } @row;

    $segments{b} = first {$three !~ /$_/} split '', $five;

    $segments{e} = first {$three !~ /$_/} split '', $two;

    $segments{d} = first {(join '', values %segments) !~ /$_/} split '', $four;

    $segments{g} = first {
        my $char = $_;
        (grep {$_ eq $char} values %segments) == 0
    } ('a' .. 'g');

    my $str = join '', @segments{'a' .. 'g'};

    my @digits;
    foreach my $digit ($displays[$i]->@*) {
        eval "\$digit =~ tr/$str/a-g/";
        $digit = join '', sort split '', $digit;
        push @digits, $decoder{$digit}
    }
    $result += join '', @digits
}

say $result;
