#!/usr/bin/perl -w

use strict;

# Optical Digits database in UCI Machine Learning Repository:
#
# http://archive.ics.uci.edu/ml/datasets/optical+recognition+of+handwritten+digits

# Usage: $0 < optitdigits.data > Test_01_A.dat
#
# Gustavo Estrela, July 1st, 2017.

# Variables are discretized in four quartiles

#
# Number of Optdigits samples: 5620.
#

my @sample;
my @statistics;

my $m = 0; # number of samples.
my $n = 0; # number of features.

while (<STDIN>)
{
  chomp $_;
  # 0,0,5,13,9,1,0,0,0,0,13,15,10,15,5,0,0,3,15,2,0,11,8,0,0,4,12,0,0,8,8,0,0,5,8,0,0,9,8,0,0,4,11,0,1,12,7,0,0,2,14,5,10,12,0,0,0,0,6,13,10,0,0,0,0
  
  if ($_ =~ /^(.*)\,(\d+)$/)
  {
    my $features_string = $1;
    my $label = $2;
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

# 1st quartile:    0-1404
# 2nd quartile: 1405-2809
# 3rd quartile: 2810-4214
# 4th quartile: 4215-5619

foreach my $index (0..($n-1))
{
  my @order_statistics = sort {$a <=> $b} @{$statistics[$index]};

  ${quartile{$index}->[1]} = $order_statistics[1404];
  ${quartile{$index}->[2]} = $order_statistics[2809];
  ${quartile{$index}->[3]} = $order_statistics[4214];
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
  foreach my $current_label (0..9)
  {
    ($current_label == $sample[$k]->[$n]) and print "1 " or print "0 ";
  }
  print "\n";
}

exit 0;
