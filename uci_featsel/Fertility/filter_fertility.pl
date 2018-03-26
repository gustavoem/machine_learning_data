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

# 1st quartile:   0-24
# 2nd quartile:  25-49
# 3rd quartile:  50-74
# 4th quartile:  75-99

foreach my $index (0..($n-1))
{
  my @order_statistics = sort {$a <=> $b} @{$statistics[$index]};

  ${quartile{$index}->[1]} = $order_statistics[24];
  ${quartile{$index}->[2]} = $order_statistics[49];
  ${quartile{$index}->[3]} = $order_statistics[74];
}


foreach my $k (0..($m-1))
{
  foreach my $index (0..($n-1))
  {
    if ($index == 0) # season
    {
      if ($sample[$k]->[$index] eq "-1")
      {
        print "0 ";
      }
      elsif ($sample[$k]->[$index] eq "-0.33")
      {
        print "1 ";
      }
      elsif ($sample[$k]->[$index] eq "0.33")
      {
        print "2 ";
      }
      else
      {
        print "3 ";
      }
    }
    elsif ($index == 5 || $index == 7) # season
    {
      if ($sample[$k]->[$index] eq "-1")
      {
        print "0 ";
      }
      elsif ($sample[$k]->[$index] eq "0")
      {
        print "1 ";
      }
      else
      {
        print "2 ";
      }
    }
    elsif ($index == 1 || $index == $n - 1 || $index == 6 || $index == 8)
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
