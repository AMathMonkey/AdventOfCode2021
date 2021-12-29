use strict;
use warnings;
use Data::Dumper;
use v5.28.1;

my $inputfile = IO::File->new('./input.txt');

my $input = <$inputfile>;
chomp $input;

my @fish = split ',', $input;

for (1..80) {
    my @newfish;
    foreach my $fish (@fish) {
        if ($fish == 0) {
            push @newfish, 6, 8
        } else {
            push @newfish, $fish - 1
        }
    }
    @fish = @newfish;
}

say scalar @fish