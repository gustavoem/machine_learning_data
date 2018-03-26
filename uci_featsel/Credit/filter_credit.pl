#!/usr/bin/perl -w

use strict;
use List::MoreUtils qw{any};

# Credit database in UCI Machine Learning Repository:
#

# Usage: $0 < crx.data > Test_01_A.dat
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

my %att_map;
$att_map{0} = {"a" => 0, "b" => 1, "?" => 2};
$att_map{3} = {"u" => 0, "y" => 1, "l" => 2, "t" => 3, "?" => 4};
$att_map{4} = {"g" => 0, "p" => 1, "gg" => 2, "?" => 3};
$att_map{5} = {"c" => 0, "d" => 1, "cc" => 2, "i" => 3,
               "j" => 4, "k" => 5, "m" => 6, "r" => 7,
               "q" => 8, "w" => 9, "x" => 10, "e" => 11,
               "aa" => 12, "ff" => 13, "?" => 14};
$att_map{6} = {"v" => 0, "h" => 1, "bb" => 2, "j" => 3,
               "n" => 4, "z" => 5, "dd" => 6, "ff" => 7, 
               "o" => 8, "?" => 9};
$att_map{8} = {"t" => 0, "f" => 1, "?" => 2};
$att_map{9} = {"t" => 0, "f" => 1, "?" => 2};
$att_map{11} = {"t" => 0, "f" => 1, "?" => 2};
$att_map{12} = {"g" => 0, "p" => 1, "s" => 2, "?" => 3};

while (<STDIN>)
{
  chomp $_;
  $_ =~ s/\+/1/;
  $_ =~ s/\-/0/;
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
      else
      {
        if ($features_line[$index] eq "?")
        {
          $features_line[$index] = 0;
        }
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

# 1st quartile:   0-172
# 2nd quartile: 173-344
# 3rd quartile: 345-516
# 4th quartile: 517-599

foreach my $index (0..($n-1))
{
  my @order_statistics = sort {$a <=> $b} @{$statistics[$index]};
  ${quartile{$index}->[1]} = $order_statistics[172];
  ${quartile{$index}->[2]} = $order_statistics[344];
  ${quartile{$index}->[3]} = $order_statistics[516];
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
  foreach my $current_label (0..2)
  {
    ($current_label == $sample[$k]->[$n]) and print "1 " or print "0 ";
  }
  print "\n";
}

exit 0;
