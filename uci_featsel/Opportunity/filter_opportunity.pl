#!/usr/bin/perl -w

use strict;

# Iris database in UCI Machine Learning Repository:
#
# https://archive.ics.uci.edu/ml/datasets/opportunity+activity+recognition

# Usage: $0 < opportunity.data > Test_01_A.dat
#
# Gustavo Estrela, May 2nd, 2018.

while (<STDIN>)
{
    chomp $_;

    my @sample_line = split " ", $_;

    my $locomotion = max ($sample_line[243], 0);
    my $left_arm = max ($sample_line[245] - 200, 0);
    my $right_arm = max ($sample_line[247] - 400, 0);
    my $activity = max ($sample_line[244] - 100, 0);

    print "$locomotion $left_arm $right_arm  $activity\n";
}

exit 0;


sub max
{
    return $_[1] if $_[1] > $_[0];
    return $_[0];
}
