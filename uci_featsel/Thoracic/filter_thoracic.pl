#!/usr/bin/perl -w

use strict;

# Credit database in UCI Machine Learning Repository:
# https://archive.ics.uci.edu/ml/datasets/Thoracic+Surgery+Data
#

# Usage: $0 < crx.data > Test_01_A.dat
#
# Gustavo Estrela, November, 2017.


my @sample;
my @statistics;

my $m = 0; # number of samples.
my $n = 0; # number of features.

my %att_map;
$att_map{0} = {"DGN1" => 0, "DGN2" => 1, "DGN3" => 2,
               "DGN4" => 3, "DGN5" => 4, "DGN6" => 5, "DGN8" => 6};
$att_map{3} = {"PRZ2" => 0, "PRZ1" => 1, "PRZ0" => 2};
$att_map{9} = {"OC11" => 0, "OC14" => 1, "OC12" => 2, "OC13" => 3};

while (<STDIN>)
{
  chomp $_;
  $_ =~ s/T/1/g;
  $_ =~ s/F/0/g;
  if ($_=~/^(.*)\,(\d+)$/)
  {
    my $features_string = $1;
    my $label = $2;
    my @features_line = split ",", $features_string;
    $n = scalar @features_line;
    # print "n = $n";

    foreach my $index (0..$#features_line)
    {
      if (exists $att_map{$index})
      {
        # print "index: $index mapped " . $sample[$k]->[$index] . " into " . $att_map{$index}->{$sample[$k]->[$index]} . "\n";
        $features_line[$index] = $att_map{$index}->{$features_line[$index]};
      }

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

# 1st quartile:   0-117
# 2nd quartile: 118-234
# 3rd quartile: 235-351
# 4th quartile: 352-469

foreach my $index (0..($n-1))
{
  my @order_statistics = sort {$a <=> $b} @{$statistics[$index]};
  ${quartile{$index}->[1]} = $order_statistics[117];
  ${quartile{$index}->[2]} = $order_statistics[234];
  ${quartile{$index}->[3]} = $order_statistics[351];
}


# a mapping for each nomial variable

# print %att_map;

foreach my $k (0..($m-1))
{
  foreach my $index (0..($n-1))
  {
    if (exists $att_map{$index})
    {
      print $sample[$k]->[$index] . " ";
    }
    else
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
  }

  print " ";
  foreach my $current_label (0..1)
  {
    ($current_label == $sample[$k]->[$n]) and print "1 " or print "0 ";
  }
  print "\n";
}

exit 0;
