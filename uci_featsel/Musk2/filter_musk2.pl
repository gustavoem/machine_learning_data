#!/usr/bin/perl -w

use strict;

# Musk2 database in UCI Machine Learning Repository:
#
# https://archive.ics.uci.edu/ml/datasets/Musk+(Version+2)

# Usage: $0 < clean2.data > Test_01_A.dat
#
# Gustavo Estrela, July 1st, 2017.

# Variables are discretized in four quartiles

#
# Number of Optdigits samples: 6598.
#

my @sample;
my @statistics;

my $m = 0; # number of samples.
my $n = 0; # number of features.

while (<STDIN>)
{
  chomp $_;
  
  # MUSK-211,211_1+13,41,-188,-145,22,-117,-7,57,-170,-39,-99,-319,-111,-228,-282,-281,-301,54,-150,-98,-196,-28,-22,2,78,48,-34,46,-91,31,94,-116,84,-23,41,-58,62,-171,3,-144,38,-153,113,-163,-319,-242,-329,-97,-69,-108,-180,-71,-26,-12,-133,107,-95,93,-140,47,27,-63,-1,12,57,-12,59,-166,-84,-131,-56,-156,-122,-286,-191,-255,-181,1,-284,-104,-185,-19,14,-31,128,-5,24,-82,-168,9,78,-200,82,13,-101,28,-50,-44,31,-156,80,-158,137,-282,-306,-295,-263,-166,-118,-244,-247,-231,3,-2,-3,14,50,99,37,84,23,66,131,109,-78,-12,-18,17,88,-20,-32,32,-128,-73,-125,-220,-93,53,-78,-19,-34,-26,4,50,17,-177,-101,-121,-65,-76,52,-41,-34,-32,-66,115,-8,-236,-60,-4,52,104,137,168,-60,-135,80,1.

  # NON-MUSK-jp13,jp13_2+4,48,-162,-101,29,-117,-86,215,19,-93,-68,-49,-22,-24,-117,-88,-297,-95,-57,-41,-57,-54,136,13,-64,-98,-3,91,131,11,-136,-116,-92,-9,-209,-33,103,-168,55,-134,132,-158,41,-33,-84,-80,-122,-153,-116,-42,-76,-64,31,73,62,-52,-32,209,-27,-17,-131,-17,-195,31,-188,-12,55,-166,-10,70,18,-135,-145,-30,-52,-35,-182,-113,-96,-19,63,-22,189,-46,-27,-156,147,5,-24,29,-147,-196,31,4,-95,-19,140,-81,68,-145,227,-159,93,-39,-54,-109,-132,-187,-145,-61,-96,-50,6,23,49,-174,-83,-94,105,160,129,-116,-68,-101,26,-129,56,-92,-170,-77,-47,-63,-88,-93,-62,-105,-110,-75,-170,-19,-46,-59,116,222,171,-151,-103,-106,-6,-31,107,-26,2,8,-165,7,-173,-235,-250,-208,14,155,131,188,-72,-173,13,0.


  if ($_ =~ /^[NON-]*MUSK-.*\+\d+,(.*),(\d).$/)
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

# 1st quartile:    0-1649
# 2nd quartile: 1650-3298
# 3rd quartile: 3299-4948
# 4th quartile: 4949-6597

foreach my $index (0..($n-1))
{
  my @order_statistics = sort {$a <=> $b} @{$statistics[$index]};

  ${quartile{$index}->[1]} = $order_statistics[1649];
  ${quartile{$index}->[2]} = $order_statistics[3298];
  ${quartile{$index}->[3]} = $order_statistics[4948];
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
  if (index($sample[$k]->[$n], "NON") != -1) 
  {
    print "1 0";
  } 
  else 
  {
    print "0 1";
  }
  print "\n";
}

exit 0;
