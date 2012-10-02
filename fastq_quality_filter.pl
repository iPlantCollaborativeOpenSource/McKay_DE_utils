#!/usr/bin/perl -w
use strict;

# Note: uses only Sanger quality scale for now.


my $scale = q(!"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHI");
my $idx = -1;
my %phred;
for my $score (split '', $scale) {
    $phred{$score} = ++$idx;
}









