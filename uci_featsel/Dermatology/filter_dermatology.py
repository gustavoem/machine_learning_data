#!/usr/bin/perl -w

use strict;

# HillValley database in UCI Machine Learning Repository:
#

# Usage: $0 < hill_valley.data > input/Promoters/Test_01_A.dat
#
# Gustavo Estrela, July 1st, 2017.

# Variables are discretized in four quartiles

#
# Number of Optdigits samples: 5000.
#

my @sample;
my @statistics;

my $m = 0; # number of samples.
my $n = 0; # number of features.

while (<STDIN>)
{
  chomp $_;
  # 39.02,36.49,38.2,38.85,39.38,39.74,37.02,39.53,38.81,38.79,37.65,39.34,38.55,39.03,37.21,36.32,37.81,38.95,36.7,39.72,37.06,37.29,36.43,36.53,36.19,38.17,37.3,36.15,36.68,36.7,36.68,36.99,38.92,37.25,37.47,36.32,35.75,35.68,34.66,34.26,35.62,36.6,34.78,34.67,34.3,33.4,31.4,31.75,31.75,32.84,33.76,35.74,34.01,33.91,36.88,34.41,35.52,36.94,36.95,35.57,38.02,37.32,39.05,37.97,37.01,38.98,38.83,38.87,38.03,38.4,38.25,38.61,36.23,37.81,37.98,38.58,38.96,38.97,39.8,38.79,38.79,36.31,36.59,38.19,37.95,39.63,39.27,37.19,37.13,37.47,37.57,36.62,36.92,38.8,38.52,38.07,36.73,39.46,37.5,39.1,0
  if ($_=~/^(.*)\,(\d+)$/)
  {
    my $features_string = $1;
    my $label = $2;
    $features_string =~ s/\?/0/;
    my @features_line = split ",", $features_string;
    $n = scalar @features_line;
    # print "n = $n";

    foreach my $index (0..$#features_line)
    {
      push @{$sample[$m]}, $features_line[$index];
      push @{$statistics[$index]}, $features_line[$index];
    }

    push @{$sample[$m]}, $label;
    $m++;
  }
  else
  {
    die "Error while parsing line: $_\n";
  }
}

my %quartile;

# 1st quartile:   0-91
# 2nd quartile:  92-183
# 3rd quartile: 184-275
# 4th quartile: 276-366

foreach my $index (0..($n-1))
{
  my @order_statistics = sort {$a <=> $b} @{$statistics[$index]};

  ${quartile{$index}->[1]} = $order_statistics[91];
  ${quartile{$index}->[2]} = $order_statistics[183];
  ${quartile{$index}->[3]} = $order_statistics[275];
}


foreach my $k (0..($m-1))
{
  foreach my $index (0..($n-1))
  {
    if ($index == $n - 1)
    {
      if ($sample[$k]->[$index] <= $quartile{$index}->[1])
      {
        print "0 ";
      }
      elsif ($sample[$k]->[$index] <= $quartile{$index}->[2])
      {
        print "1 ";
      }
      elsif ($sample[$k]->[$index] <= $quartile{$index}->[3])
      {
        print "2 ";
      }
      else
      {
        print "3 ";
      }
    }
    else
    {
      print $sample[$k]->[$index] . " ";
    }
  }

  print " ";
  foreach my $current_label (0..2)
  {
    ($current_label == $sample[$k]->[$n]) and print "1 " or print "0 ";
  }
  print "\n";
}

exit 0;
