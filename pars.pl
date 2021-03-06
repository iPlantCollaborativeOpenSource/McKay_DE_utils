#!/usr/bin/perl -w
use strict;
use lib '/usr/local2/sheldon/lib';
use DE_util;

use constant BINARY => '/usr/local2/sheldon/bin/pars';

# Command line arguments for PARS (not exhaustive)
# J Jumble input order expects random number key and number of times to jumble
# O outgroup root expects the species number (integer)
# I BOOLEAN input sequences interleaved (default yes)
# 5 BOOLEAN print sequence at nodes of tree
# i non PHYLIP option for input file (required)

# parse-spcific option string
# Letters followed by a colon expect an argument
# Letters without a colon are BOOLEAN
my $option_string = '5IJ:O:i:';
my $opt = get_options($option_string,{});
my %opt = %$opt;

# sanity check DNAML specific arguments
check_options(%opt);
cleanup();

# standardize the names, save them to infile
my $names = obfuscate_names($opt{i},'infile');

# random number string
my $rand = random_number_key();

# build up command file
my $stdin = ''; 
my $jumble = $opt{J} || 1;
$stdin .= "O\n$opt{O}\n" if $opt{O};
$stdin .= "I\n"          unless $opt{I};      
$stdin .= "5\n"          unless $opt{5};
$stdin .= "J\n$rand\n$opt{J}\n" if $opt{J} && !$opt{M};
$stdin .= "M\nD\n$opt{M}\n$rand\n$jumble\n" if $opt{M};
$stdin .= "Y\n\n";

# run the job (cross you fingers!)
run($stdin,BINARY);

# clean up
my $infile = $opt{i};
$infile =~ s/\.[^.]+$//;
deobfuscate_names('outfile',"output.txt",$names);
deobfuscate_names('outtree',"treefile.newick",$names);
cleanup();


sub check_options {
    my %opt = @_;
    # currently no unique options for DNAPARS
}
