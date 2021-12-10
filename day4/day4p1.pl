use strict;
use warnings;
use Data::Dumper;
use List::Util qw(all sum);
use v5.30.0;

my $input = IO::File->new('./input.txt');

my @input = <$input>;
chomp @input;

my @nums = split ',', shift @input;
shift @input;

my @boards;

while (@input) {
    my @board;
    my $line;
    while (defined($line = shift @input) && $line ne '') {
        my @row = split ' ', $line;
        push @board, \@row;
    }
    push @boards, \@board;
}

my %called;
while (defined(my $num = shift @nums)) {
    $called{$num} = undef;
    foreach my $board (@boards) {
        for my $i (0 .. $#$board) {
            if (all {exists $called{$_}} $board->[$i]->@*) {
                win($board, \%called, $num);
                exit;
            }
        }
        for my $j (0 .. $#{$board->[0]}) {
            my @col;
            for my $i (0 .. $#$board) {
                push(@col, $board->[$i][$j])
            }
            if (all {exists $called{$_}} @col) {
                win($board, \%called, $num);
                exit;
            }
        }
    }
}

sub win {
    my @board = shift->@*,
    my %called = shift->%*;
    my $num = shift;

    my @uncalled;

    foreach my $row (@board) {
        push(@uncalled, grep {not exists($called{$_})} $row->@*)
    }
    say sum(@uncalled) * $num;
}