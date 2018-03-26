#!/usr/bin/perl -w

use strict;

# Waveform database in UCI Machine Learning Repository:
#
# http://archive.ics.uci.edu/ml/datasets/waveform+database+generator+%28version+1%29

# Usage: $0 < waveform.data > input/Promoters/Test_01_A.dat
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
  
  # -1.23,-1.56,-1.75,-0.28,0.60,2.22,0.85,0.21,-0.20,0.89,1.08,4.20,2.89,7.75,4.59,3.15,5.12,3.32,1.20,0.24,-0.56,2
  
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

# 1st quartile:    0-1249
# 2nd quartile: 1250-2499
# 3rd quartile: 2500-3749
# 4th quartile: 3750-5000

foreach my $index (0..($n-1))
{
  my @order_statistics = sort {$a <=> $b} @{$statistics[$index]};

  ${quartile{$index}->[1]} = $order_statistics[1249];
  ${quartile{$index}->[2]} = $order_statistics[2499];
  ${quartile{$index}->[3]} = $order_statistics[3749];
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
