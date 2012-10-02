#!/usr/bin/perl -w
use strict;
while (<>) {
    chomp;
    if (/!$/ && length == 42) {
	chop;
    }
    print "$_\n";
}
