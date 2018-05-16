#!/usr/bin/perl -w

use strict;

# Iris database in UCI Machine Learning Repository:
#
# https://archive.ics.uci.edu/ml/datasets/opportunity+activity+recognition

# Usage: $0 < opportunity.data > Test_01_A.dat
#
# Gustavo Estrela, May 2nd, 2018.

# Mapping actions to 31 features
# 
# features  0 - 3  represent Locomotion
# features  4 - 16 represent Left arm action
# features 17 - 29 represent Right arm action
#
# There are 5 activities 

my $current_activity = 0;
my @bag_of_actions = (0)x30;

my $i = 0;

while (<STDIN>)
{
    chomp $_;
    my @sample_line = split " ", $_;

    $i += 1;
    
    my $activity = max ($sample_line[244] - 100, 0);
    my $locomotion = max ($sample_line[243], 0);
    if ($locomotion > 2)
    {
        $locomotion -= 1;
    }
    my $left_arm = max ($sample_line[245] - 200, 0);
    my $right_arm = max ($sample_line[247] - 400, 0);

    if ($activity != 0 and $current_activity == 0)
    {
        $current_activity = $activity;
    }
    
    if ($current_activity != 0 and $activity == 0)
    {
        # print last activity
        for my $f (@bag_of_actions)
        {
            print "$f ";
        }
        for my $i (1..5)
        {
            print " 0" if $i != $current_activity;
            print " 1" if $i == $current_activity;
        }
        print "\n";

        # start an empty bag
        @bag_of_actions = (0)x30;
        $current_activity = 0;
    }

    
    if ($activity != 0 and $current_activity == $activity)
    {
        $bag_of_actions[$locomotion - 1] = 1 if $locomotion != 0;
        $bag_of_actions[3 + $left_arm] = 1 if $left_arm != 0;
        $bag_of_actions[16 + $right_arm] = 1 if $right_arm != 0;
    }
    elsif ($activity != 0) # and $current_activity != $activity
    {
        # print last activity
        for my $f (@bag_of_actions)
        {
            print "$f ";
        }
        for my $i (1..5)
        {
            print " 0" if $i != $current_activity;
            print " 1" if $i == $current_activity;
        }
        print "\n";
        
        # start new activity
        $current_activity = $activity;
        @bag_of_actions = (0)x30;
        $bag_of_actions[$locomotion - 1] = 1 if $locomotion != 0;
        $bag_of_actions[3 + $left_arm] = 1 if $left_arm != 0;
        $bag_of_actions[16 + $right_arm] = 1 if $right_arm != 0;
    }
}

exit 0;


sub max
{
    return $_[1] if $_[1] > $_[0];
    return $_[0];
}
