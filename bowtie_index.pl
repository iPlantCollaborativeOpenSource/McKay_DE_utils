#!/usr/bin/perl -w
use strict;

# path to bowtie index executable
use constant BOWTIE => '/home/smckay/bowtie-0.12.7/bowtie-build';

# single input file 
my $fa_file = shift;

# single name
my $name = shift;

# sanity checks
$fa_file && $name || usage ('A sequence file and a name are required inputs');
-e $fa_file || usage ("Sequence file $fa_file does not exist!");


# decompress input if required
if ($fa_file =~ /\.gz$/) {
    system "gunzip $fa_file";
    $fa_file =~ s/\.gz$//;
}
elsif ($fa_file =~ /\.bz2?$/) {
    system "bunzip2 $fa_file";
    $fa_file =~s/\.bz2?$//;
}

my $cmd = BOWTIE . " $fa_file $name";
system $cmd;

mkdir $name;
unlink $fa_file;
system "mv $name\*.ebwt $name";

exit 0;

sub usage {
    my $msg = shift;
    die <<END;
  Error: $msg
  Usage: bowtie_index.pl seqfile name

END
}
