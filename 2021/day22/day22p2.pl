use strict;
use warnings;
use Data::Dumper;
use v5.28.1;
use PDL;
use PDL::NiceSlice;
use List::MoreUtils qw(first_index);

my $inputfile = IO::File->new('./input.txt');

chomp(my @input = <$inputfile>);

my @xcoords;
my @ycoords;
my @zcoords;

foreach my $line (@input) {
    my ($xmin, $xmax, $ymin, $ymax, $zmin, $zmax) =
        $line =~ /x=(-?\d+)\.\.(-?\d+),y=(-?\d+)\.\.(-?\d+),z=(-?\d+)\.\.(-?\d+)/;

    push @xcoords, $xmin, $xmax + 1;
    push @ycoords, $ymin, $ymax + 1;
    push @zcoords, $zmin, $zmax + 1;
}

@xcoords = sort {$a <=> $b} List::Util::uniq(@xcoords);
@ycoords = sort {$a <=> $b} List::Util::uniq(@ycoords);
@zcoords = sort {$a <=> $b} List::Util::uniq(@zcoords);

my $minx = $xcoords[0];
my $miny = $ycoords[0];
my $minz = $zcoords[0];

@xcoords = map {$_ - $minx} @xcoords;
@ycoords = map {$_ - $miny} @ycoords;
@zcoords = map {$_ - $minz} @zcoords;

my $prev;

my @xdiffs;
$prev = 0;
foreach my $xcoord (@xcoords[1 .. $#xcoords]) {
    push @xdiffs, $xcoord - $prev;
    $prev = $xcoord;
}

my @ydiffs;
$prev = 0;
foreach my $ycoord (@ycoords[1 .. $#ycoords]) {
    push @ydiffs, $ycoord - $prev;
    $prev = $ycoord;
}

my @zdiffs;
$prev = 0;
foreach my $zcoord (@zcoords[1 .. $#zcoords]) {
    push @zdiffs, $zcoord - $prev;
    $prev = $zcoord;
}

my $grid = zeroes byte, scalar(@xcoords), scalar(@ycoords), scalar(@zcoords);

foreach my $line (@input) {
    my ($command, $xmin, $xmax, $ymin, $ymax, $zmin, $zmax) =
        $line =~ /(on|off) x=(-?\d+)\.\.(-?\d+),y=(-?\d+)\.\.(-?\d+),z=(-?\d+)\.\.(-?\d+)/;

    $xmin = first_index {$_ == $xmin - $minx} @xcoords;
    $xmax = first_index {$_ == $xmax + 1 - $minx} @xcoords;
    $ymin = first_index {$_ == $ymin - $miny} @ycoords;
    $ymax = first_index {$_ == $ymax + 1 - $miny} @ycoords;
    $zmin = first_index {$_ == $zmin - $minz} @zcoords;
    $zmax = first_index {$_ == $zmax + 1 - $minz} @zcoords;

    $grid($xmin : $xmax - 1, $ymin : $ymax - 1, $zmin : $zmax - 1) .= ($command eq 'on') ? 1 : 0;
}

my $result = 0;

push @xdiffs, 0;
push @ydiffs, 0;
push @zdiffs, 0;

$PDL::BIGPDL = 1;
my $xdiffs = pdl @xdiffs;
my $ydiffs = pdl @ydiffs;
my $zdiffs = pdl @zdiffs;

$xdiffs = $xdiffs->dummy(1, scalar @ydiffs)->dummy(2, scalar @zdiffs);
$ydiffs = $ydiffs->dummy(0, scalar @xdiffs)->dummy(2, scalar @zdiffs);
$zdiffs = $zdiffs->dummy(0, scalar @xdiffs)->dummy(1, scalar @ydiffs);

my $diffs = longlong($xdiffs * $ydiffs * $zdiffs);
say sum $diffs->where($grid == 1);

$PDL::BIGPDL = 0;
