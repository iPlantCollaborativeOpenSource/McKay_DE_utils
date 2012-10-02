#!/usr/bin/perl -w
use strict;
use lib '/usr/local2/sheldon/lib';
use DE_util;
use Bio::AlignIO;

use constant FORMATS => [
			 qw/
			 clustalw
			 fasta
			 largemultifasta
			 mega
			 nexus
			 phylip
			 stockholm/
			 ];

my $option_string = 'i:o:f:g:';
my $opt = get_options($option_string,{});
my %opt = %$opt;

# sanity check DNAML specific arguments
check_options(%opt);


my $in  = Bio::AlignIO->new(-file => $opt{i}, -format => lc $opt{f});
my $out = Bio::AlignIO->new(-file => ">$opt{o}", -format => lc $opt{g});

while (my $aln = $in->next_aln) {
    $out->write_aln($aln);
}

sub check_options {
    my %opt = @_;
    my $formats  = FORMATS;

    die "an output file is required"   unless $opt{o};
    die "an input format is required"  unless $opt{f};
    if ($opt{f}) {
	die "in format $opt{f} is not supported"  unless grep /$opt{f}/i, @$formats; 
    }
    if ($opt{g}) {
	die "out format $opt{g} is not supported" unless grep /$opt{g}/i, @$formats;
    }
    die "an output format is required" unless $opt{g};
}

