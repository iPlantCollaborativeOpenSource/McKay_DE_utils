#!/usr/bin/perl -w
use strict;
use File::Copy 'move';
use File::Basename;

while (<DATA>) {
  chomp;
  ($_, my $group, my $release) = split;
  $_ = lc $_;
  my $term  = ucfirst $_;
  my $unzipped = `\\ls $term*.fa 2>/dev/null`;
  my $zipped   = `\\ls $term*.gz 2>/dev/null`;
  my $touched  = `\\ls $term.txt 2>/dev/null`;
  chomp $unzipped;
  chomp $zipped;
  chomp $touched;

  print STDERR "Checking to make sure $_ is not done...";
  sleep 1;
  if ($zipped || $unzipped || $touched) {
      print STDERR "Oops, found it!\n\n";
      next;
      sleep 5;
  }
  else {
      system "touch $term.txt";
      print STDERR "No, we are good to go!\n\n";
  }
  my $url;
  if ($group eq 'plants') {
     $url = "ftp://ftp.ensemblgenomes.org/pub/plants/release-$release/fasta/$_/dna/*.dna.toplevel.fa.gz";
  }
  elsif ($group eq 'metazoa') {
      $url = "ftp://ftp.ensembl.org/pub/release-$release/fasta/$_/dna/*.dna.toplevel.fa.gz";
  }
  system "wget $url";
  system "gunzip $term*gz";

  chomp(my $file = `\\ls $term*fa`);
  my $name = basename($file, ".$release.dna.toplevel.fa");

  system "perl -i -pe 's/^\\>\\S*chloro\\S*/\\>C/i' $file";
  system "perl -i -pe 's/^\\>\\S*mito\\S*/\\>M/i' $file";
  system "perl -i -pe 's/^\\>\\S*Pt\\S*/\\>C/' $file";
  system "perl -i -pe 's/^\\>Mt\\S*/\\>M/' $file";

  system "bowtie-build $file $name";
}

print STDERR "OK, we got the genomes, now putting them away...\n";

#arrange();

# make a directory for each reference genome
sub arrange {
    my %seen;
    while (<*.*>) {
        next if /README/;
        next if -d;
        next if /\.pl/;
        next unless /_/;
        my ($basename) = /([^.]+)/;
        unless ($seen{$basename}++) {
            mkdir($basename) || die $!;
        }
        move($_, $basename);
    }
}

# update with each release
__DATA__
arabidopsis_lyrata plants 13
arabidopsis_thaliana plants 13
brachypodium_distachyon plants 13
brassica_rapa plants 13
chlamydomonas_reinhardtii plants 13
cyanidioschyzon_merolae plants 13
glycine_max plants 13
oryza_glaberrima plants 13
oryza_indica plants 13
oryza_sativa plants 13
physcomitrella_patens plants 13
populus_trichocarpa plants 13
selaginella_moellendorffii plants 13
sorghum_bicolor plants 13
vitis_vinifera plants 13
zea_mays plants 13
Caenorhabditis_elegans metazoa 66
Drosophila_melanogaster metazoa 66
Saccharomyces_cerevisiae metazoa 66
homo_sapiens metazoa 66
bos_taurus metazoa 66
canis_familiaris metazoa 66
danio_rerio metazoa 66
Felis_catus metazoa 66
Homo_sapiens metazoa 66
Mus_musculus metazoa 66 
Pan_troglodytes metazoa 66
Rattus_norvegicus metazoa 66
Tursiops_truncatus metazoa 66
Xenopus_tropicalis metazoa 66
