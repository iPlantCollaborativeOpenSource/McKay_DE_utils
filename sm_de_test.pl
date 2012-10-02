#!/usr/bin/perl -w
use strict;

my $user = $ENV{USER} || "Random User";
open OUT, ">hello.txt";
print OUT "Hello $user!\n";
close OUT;

exit 0;
