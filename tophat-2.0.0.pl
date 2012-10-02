#!/usr/bin/perl -w
use strict;
use warnings;
use Getopt::Long qw(:config no_ignore_case no_auto_abbrev pass_through);

use constant TOPHATP    => '/usr/local2/tophat-2.0.0.Linux_x86_64/';
use constant BOWTIEP    => 'bowtie-0.12.7';
use constant SAMTOOLSP  => '/usr/local2/samtools-0.1.18/';

# Define worflow options
my (@query_file, $database_path, $user_database_path, $annotation_path, $user_annotation_path, $null);

my $out_alignment = "";
my $format = 'SE';

GetOptions( "query|query1|input=s" => \@query_file,
	    "database=s" => \$database_path,
	    "user_database=s" => \$user_database_path,
	    "output=s" => \$null );

# Allow over-ride of system-level database path with user
# May not need to do this going forward...
if (defined($user_database_path)) {
  $database_path = $user_database_path;
  $database_path = "$database_path\/$database_path";
}

my $success = undef;

chomp($ENV{PATH} = `echo \$PATH`);
$ENV{PATH} = join(':',$ENV{PATH},TOPHATP,BOWTIEP,SAMTOOLSP);

#report("PATH: $ENV{PATH}");

# is this a directory or a file
if (@query_file == 1) {
    if (-d $query_file[0]) {
	my $thing = shift @query_file;
	while (<$thing/*>) {
	    push @query_file, $_;
	}
    }
}


for my $query_file (@query_file) {
    system "rm -fr tophat_out";
    # Grab any flags or options we don't recognize and pass them as plain text
    # Need to filter out options that are handled by the GetOptions call
    my @args_to_reject = qw(-xxxx);
    my $TOPHAT_ARGS = join(" ", @ARGV);
    foreach my $a (@args_to_reject) {
	if ($TOPHAT_ARGS =~ /$a/) {
	    report("Most TopHat arguments are legal for use with this script, but $a is not. Please omit it and submit again");
	    exit 1;
	}
    }

    my $app = TOPHATP.'tophat';
    my $align_command = "$app $TOPHAT_ARGS $database_path $query_file";
    
    chomp(my $basename = `basename $query_file`);
    $basename =~ s/\.\S+$//;
    system "rm -fr $basename";
    report($align_command);
    system $align_command;
    system "mv tophat_out $basename";
    
    $success++ if -e "$basename/accepted_hits.bam";
    last;
}

$success ? exit 0 : exit 1;

sub report {
    print STDERR "$_[0]\n";
}

