#!/usr/bin/perl -w

use strict;

# Optical Digits database in UCI Machine Learning Repository:
#
# https://archive.ics.uci.edu/ml/machine-learning-databases/car/

# Usage: $0 < optitdigits.data > Test_01_A.dat
#
# Gustavo Estrela, July 8st, 2017.

# Variables are discretized in four quartiles

#
# Number of Car Evaluation samples: 1728.
#

my @sample;
my @statistics;

my $m = 0; # number of samples.
my $n = 0; # number of features.

# Attribute Values:
#    buying       v-high, high, med, low
#    maint        v-high, high, med, low
#    doors        2, 3, 4, 5-more
#    persons      2, 4, more
#    lug_boot     small, med, big
#    safety       low, med, high
my %att_int = ("2" => 2, "3" => 3, "4" => 4, "5" => 5,
  "vhigh" => 3, "high" => 2, "med" => 1, "low" => 0,
                 "big" => 2,         , "small" => 0, 
  "more" => 6, "5more" => 5);

my %class_int = ("unacc" => 0, "acc" => 1, "good" => 2, "vgood" => 3);

while (<STDIN>)
{
  chomp $_;
  # low,high,4,4,small,low,unacc
  # low,high,4,4,small,med,acc
  # low,high,4,4,small,high,acc
  
  if ($_ =~ /^(.*)\,(\S+)$/)
  {
    my $features_string = $1;
    my $label = $class_int{$2};
    my @features_line = split ",", $features_string;
    
    foreach my $index (0..$#features_line)
    {
      my $attr = $att_int{$features_line[$index]};
      if ($attr eq "")
      {
        print "ruim: " . $features_line[$index];
      }
      print "$attr ";
    }

    print " ";
    foreach my $current_label (0..3)
    {
      ($current_label == $label) and print "1 " or print "0 ";
    }
    print "\n";    
  }
  else
  {
    die "Error while parsing line: $_\n";
  }
}

exit 0;
