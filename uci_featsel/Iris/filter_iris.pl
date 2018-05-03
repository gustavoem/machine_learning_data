#!/usr/bin/perl -w

use strict;

# Iris database in UCI Machine Learning Repository:
#
# https://archive.ics.uci.edu/ml/datasets/iris

# Usage: $0 < iris.data > Test_01_A.dat
#
# Gustavo Estrela, July 8th, 2017.

# Variables are discretized in four quartiles

#
# Number of Iris samples: 150.
#

my @sample;
my @statistics;
my $m = 0; # number of samples.
my $n = 0; # number of features.
my %class_int = ("setosa" => 0, "versicolor" => 1, "virginica" => 2);

while (<STDIN>)
{
  chomp $_;
  
  # 5.0,3.3,1.4,0.2,Iris-setosa
  # 7.0,3.2,4.7,1.4,Iris-versicolor
  # 6.4,3.2,4.5,1.5,Iris-virginica

  if ($_ =~ /^(.*),\s*Iris-(\S+)$/)
  {
    my $features_string = $1;
    my $label = $class_int{$2};
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

# 1st quartile:    0-36
# 2nd quartile:   37-74
# 3rd quartile:   75-112
# 4th quartile:  113-149

foreach my $index (0..($n-1))
{
  my @order_statistics = sort {$a <=> $b} @{$statistics[$index]};

  ${quartile{$index}->[1]} = $order_statistics[36];
  ${quartile{$index}->[2]} = $order_statistics[74];
  ${quartile{$index}->[3]} = $order_statistics[112];
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
  foreach my $current_label (0..2)
  {
    ($current_label == $sample[$k]->[$n]) and print "1 " or print "0 ";
  }
  print "\n";
}

exit 0;
