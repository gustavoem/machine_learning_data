#!/usr/bin/perl -w

use strict;

# Optical Digits database in UCI Machine Learning Repository:
#
# http://archive.ics.uci.edu/ml/datasets/optical+recognition+of+handwritten+digits

# Usage: $0 < promoters.data > input/Promoters/Test_01_A.dat
#
# Gustavo Estrela, July 1st, 2017.

# Variables are discretized in four quartiles

#
# Number of Optdigits samples: 2600.
#

my @sample;
my @statistics;

my $m = 0; # number of samples.
my $n = 0; # number of features.

while (<STDIN>)
{
  chomp $_;
  # 485 477 537 479 452 471 491 476 475 473 455 500 456 507 478 491 447 422 480 482 515 482 464 484 477 496 509 491 459 482 483 505 508 458 509 517 479 487 473 472 474 531 485 508 517 489 507 515 440 465 550 532 450 483 460 469 507 485 479 458 516 480 460 479 648 480 561 481 474 474 544 484 490 451 494 480 486 459 521 500 466 457 494 492 488 497 477 461 473 464 476 471 481 507 474 500 481 536 464 501 479 480 483 462 470 181 510 470 431 482 496 481 469 539 491 482 481 476 533 495 474 485 479 495 465 541 493 488 452 481 491 501 477 479 503 529 540 504 482 463 477 530 508 488 488 474 479 506 478 511 501 474 483 575 478 482 461 480 543 415 527 477 487 486 511 474 477 482 476 516 466 492 561 479 472 457 497 475 452 491 477 454 461 472 481 490 526 490 459 478 461 516 511 544 519 487 485 475 477 476 478 470 493 581 484 476 521 474 492 459 487 504 464 485 478 465 603 475 481 491 555 424 528 511 384 525 459 478 477 539 479 508 471 517 482 518 473 478 506 476 507 434 466 480 547 518 516 476 492 454 463 497 477 531 472 495 532 496 492 480 480 479 517 470 470 500 468 477 486 553 490 499 450 469 466 479 476 401 491 551 477 517 492 475 537 516 472 451 484 471 469 523 496 482 458 487 477 457 458 493 458 517 478 482 474 517 482 488 490 485 440 455 464 531 483 467 494 488 414 491 494 497 501 476 481 485 478 476 491 492 523 492 476 464 496 473 658 507 628 484 468 448 502 618 438 486 496 535 452 497 490 485 504 477 481 473 517 476 479 483 482 458 464 466 473 482 497 479 497 495 489 483 500 490 479 471 468 496 419 513 475 471 514 479 480 486 480 477 494 454 480 539 477 441 482 461 484 510 475 485 480 474 474 442 477 502 402 478 504 476 484 475 488 486 524 506 480 451 512 498 478 485 495 476 496 485 496 485 486 482 505 528 496 533 504 512 474 646 526 485 541 487 568 492 467 479 483 479 546 476 457 463 517 471 482 630 481 494 440 509 507 512 496 488 462 498 480 511 500 437 537 470 515 476 467 401 485 499 495 490 508 463 487 531 515 476 482 463 467 479 477 481 477 485 511 485 481 479 475 496  -1
  
  if ($_ =~ /^(.*)\s+([-]*\d+)$/)
  {
    my $features_string = $1;
    my $label = $2;
    my @features_line = split " ", $features_string;
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

# 1st quartile:    0-649
# 2nd quartile:  650-1299
# 3rd quartile: 1300-1949
# 4th quartile: 1950-2599

foreach my $index (0..($n-1))
{
  my @order_statistics = sort {$a <=> $b} @{$statistics[$index]};

  ${quartile{$index}->[1]} = $order_statistics[649];
  ${quartile{$index}->[2]} = $order_statistics[1299];
  ${quartile{$index}->[3]} = $order_statistics[1949];
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
  if ($sample[$k]->[$n] eq "-1")
  {
    print "0 1";
  }
  else
  {
    print "1 0";
  }
  print "\n";
}

exit 0;
