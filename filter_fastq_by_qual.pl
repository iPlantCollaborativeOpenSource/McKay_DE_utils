#!/usr/bin/perl -w
use strict;
use Data::Dumper;

use constant MIN_FRACTION => 0.5;
use constant THRESHOLD    => 20;

my %phred;
my $quals = qq(\!\"\#\$\%\&\'\(\)\*\+\,\-\.\/0123456789\:\;\<\=\>\?\@ABCDEFGHI);

my $idx = -1;
for my $scr (split '', $quals) {
    $phred{$scr} = ++$idx;
}

my $infile = shift;

open IN, $infile || die $!;

my ($line,$print);
while (<IN>) {
    if (/^@/) {
	$print = $_;
	$line = 1;
	next;
    }
    if (++$line < 4) {
	$print .= $_;
	next;
    }
    my @t = split('', $_); 
    pop @t;
    my $good;
    for my $scr (@t) {
	my $score = $phred{$scr};
        #print STDERR "$score ";
	$good++ if $score >= THRESHOLD;
    }
   # print STDERR "\n$_";
    $good ||= 1;
    if (int($good/@t + 0.5) >= MIN_FRACTION) {
	$print .= $_;
	print $print;
    }
}
