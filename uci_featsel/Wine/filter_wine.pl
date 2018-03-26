#!/usr/bin/perl -w

use strict;

# Iris database in UCI Machine Learning Repository:
#
# https://archive.ics.uci.edu/ml/machine-learning-databases/wine/

# Usage: $0 < iris.data > Test_01_A.dat
#
# Gustavo Estrela, July 8st, 2017.

# Variables are discretized in four quartiles

#
# Number of Iris samples: 178.
#

my @sample;
my @statistics;
my $m = 0; # number of samples.
my $n = 0; # number of features.
my %class_int = ("setosa" => 0, "versicolor" => 1, "virginica" => 2);

while (<STDIN>)
{
  chomp $_;
  
  # 1,14.23,1.71,2.43,15.6,127,2.8,3.06,.28,2.29,5.64,1.04,3.92,1065
  # 1,13.2,1.78,2.14,11.2,100,2.65,2.76,.26,1.28,4.38,1.05,3.4,1050
  # 1,13.16,2.36,2.67,18.6,101,2.8,3.24,.3,2.81,5.68,1.03,3.17,1185

  if ($_ =~ /^(\d),(.*)$/)
  {
    my $features_string = $2;
    my $label = $1;
    my @features_line = split ",", $features_string;
    $n = scalar @features_line;

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

# 1st quartile:    0-43
# 2nd quartile:   44-88
# 3rd quartile:   89-133
# 4th quartile:  134-177

foreach my $index (0..($n-1))
{
  my @order_statistics = sort {$a <=> $b} @{$statistics[$index]};

  ${quartile{$index}->[1]} = $order_statistics[43];
  ${quartile{$index}->[2]} = $order_statistics[88];
  ${quartile{$index}->[3]} = $order_statistics[177];
}


foreach my $k (0..($m-1))
{
  foreach my $index (0..($n-1))
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

  print " ";
  foreach my $current_label (1..3)
  {
    ($current_label == $sample[$k]->[$n]) and print "1 " or print "0 ";
  }
  print "\n";
}

exit 0;
