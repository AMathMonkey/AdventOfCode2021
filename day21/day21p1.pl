use strict;
use warnings;
use Data::Dumper;
use v5.30.0;

my $inputfile = IO::File->new('./input.txt');

chomp(my @input = <$inputfile>);

shift(@input) =~ /starting position: (\d+)/;
my $p1pos = $1;
shift(@input) =~ /starting position: (\d+)/;
my $p2pos = $1;

sub roll () {
    state $num = 1;
    $num = ($num % 100) + 1;
    $num - 1
}

sub sim { my ($p1pos, $p2pos) = @_;
    my ($p1score, $p2score) = (0, 0);
    my $rolls = 0;

    while (1) {
        $p1pos += roll + roll + roll;
        $rolls += 3;
        $p1pos = (($p1pos - 1) % 10) + 1;
        $p1score += $p1pos;
        if ($p1score >= 1000) {
            say "p1 wins, p2 had $p2score points and there were $rolls rolls";
            return $p2score * $rolls;
        }
        $p2pos += roll + roll + roll;
        $rolls += 3;
        $p2pos = (($p2pos - 1) % 10) + 1;
        $p2score += $p2pos;
        if ($p2score >= 1000) {
            say "p2 wins, p1 had $p1score points and there were $rolls rolls";
            return $p1score * $rolls;
        }
    }
}

say sim($p1pos, $p2pos);