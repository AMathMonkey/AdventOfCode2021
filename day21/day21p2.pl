use strict;
use warnings;
use Data::Dumper;
use v5.30.0;
use List::Util qw(max);

my $inputfile = IO::File->new('./input.txt');

chomp(my @input = <$inputfile>);

shift(@input) =~ /starting position: (\d+)/;
my $p1pos = $1;
shift(@input) =~ /starting position: (\d+)/;
my $p2pos = $1;

my %cache;

sub sim { my ($p1pos, $p2pos, $p1score, $p2score, $player) = @_;
    my $ret = $cache{"$p1pos,$p2pos,$p1score,$p2score"};
    return $ret if defined $ret;
    if ($p1score >= 21) {
        $cache{"$p1pos,$p2pos,$p1score,$p2score"} = [1, 0];
        return [1, 0]
    }
    if ($p2score >= 21) {
        $cache{"$p1pos,$p2pos,$p1score,$p2score"} = [0, 1];
        return [0, 1]
    }
    my ($p1wins, $p2wins) = (0, 0);
    my $res;
    if ($player == 1) {
        my $newp1pos;
        $newp1pos = $p1pos + 3;
        $newp1pos = (($newp1pos - 1) % 10) + 1;
        $res = __SUB__->($newp1pos, $p2pos, $p1score + $newp1pos, $p2score, 2);
        $p1wins += $res->[0];
        $p2wins += $res->[1];

        $newp1pos = $p1pos + 4;
        $newp1pos = (($newp1pos - 1) % 10) + 1;
        $res = __SUB__->($newp1pos, $p2pos, $p1score + $newp1pos, $p2score, 2);
        for (1 .. 3) {
            $p1wins += $res->[0];
            $p2wins += $res->[1];
        }

        $newp1pos = $p1pos + 5;
        $newp1pos = (($newp1pos - 1) % 10) + 1;
        $res = __SUB__->($newp1pos, $p2pos, $p1score + $newp1pos, $p2score, 2);
        for (1 .. 6) {
            $p1wins += $res->[0];
            $p2wins += $res->[1];
        }

        $newp1pos = $p1pos + 6;
        $newp1pos = (($newp1pos - 1) % 10) + 1;
        $res = __SUB__->($newp1pos, $p2pos, $p1score + $newp1pos, $p2score, 2);
        for (1 .. 7) {
            $p1wins += $res->[0];
            $p2wins += $res->[1];
        }

        $newp1pos = $p1pos + 7;
        $newp1pos = (($newp1pos - 1) % 10) + 1;
        $res = __SUB__->($newp1pos, $p2pos, $p1score + $newp1pos, $p2score, 2);
        for (1 .. 6) {
            $p1wins += $res->[0];
            $p2wins += $res->[1];
        }

        $newp1pos = $p1pos + 8;
        $newp1pos = (($newp1pos - 1) % 10) + 1;
        $res = __SUB__->($newp1pos, $p2pos, $p1score + $newp1pos, $p2score, 2);
        for (1 .. 3) {
            $p1wins += $res->[0];
            $p2wins += $res->[1];
        }

        $newp1pos = $p1pos + 9;
        $newp1pos = (($newp1pos - 1) % 10) + 1;
        $res = __SUB__->($newp1pos, $p2pos, $p1score + $newp1pos, $p2score, 2);
        $p1wins += $res->[0];
        $p2wins += $res->[1];

        return [$p1wins, $p2wins]
    } else {
        my $newp2pos;
        $newp2pos = $p2pos + 3;
        $newp2pos = (($newp2pos - 1) % 10) + 1;
        $res = __SUB__->($p1pos, $newp2pos, $p1score, $p2score + $newp2pos, 1);
        $p1wins += $res->[0];
        $p2wins += $res->[1];

        $newp2pos = $p2pos + 4;
        $newp2pos = (($newp2pos - 1) % 10) + 1;
        $res = __SUB__->($p1pos, $newp2pos, $p1score, $p2score + $newp2pos, 1);
        for (1 .. 3) {
            $p1wins += $res->[0];
            $p2wins += $res->[1];
        }

        $newp2pos = $p2pos + 5;
        $newp2pos = (($newp2pos - 1) % 10) + 1;
        $res = __SUB__->($p1pos, $newp2pos, $p1score, $p2score + $newp2pos, 1);
        for (1 .. 6) {
            $p1wins += $res->[0];
            $p2wins += $res->[1];
        }

        $newp2pos = $p2pos + 6;
        $newp2pos = (($newp2pos - 1) % 10) + 1;
        $res = __SUB__->($p1pos, $newp2pos, $p1score, $p2score + $newp2pos, 1);
        for (1 .. 7) {
            $p1wins += $res->[0];
            $p2wins += $res->[1];
        }

        $newp2pos = $p2pos + 7;
        $newp2pos = (($newp2pos - 1) % 10) + 1;
        $res = __SUB__->($p1pos, $newp2pos, $p1score, $p2score + $newp2pos, 1);
        for (1 .. 6) {
            $p1wins += $res->[0];
            $p2wins += $res->[1];
        }

        $newp2pos = $p2pos + 8;
        $newp2pos = (($newp2pos - 1) % 10) + 1;
        $res = __SUB__->($p1pos, $newp2pos, $p1score, $p2score + $newp2pos, 1);
        for (1 .. 3) {
            $p1wins += $res->[0];
            $p2wins += $res->[1];
        }

        $newp2pos = $p2pos + 9;
        $newp2pos = (($newp2pos - 1) % 10) + 1;
        $res = __SUB__->($p1pos, $newp2pos, $p1score, $p2score + $newp2pos, 1);
        $p1wins += $res->[0];
        $p2wins += $res->[1];

        return [$p1wins, $p2wins]
    }
}

say max sim($p1pos, $p2pos, 0, 0, 1)->@*;