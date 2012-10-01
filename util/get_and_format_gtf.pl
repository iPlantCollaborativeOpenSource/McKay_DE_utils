#!/usr/bin/perl -w
use strict;
use File::Copy 'move';
use File::Basename;
use constant RELEASE => 13;
use constant URL     => 'ftp://ftp.ensemblgenomes.org/pub/plants/release-'.RELEASE.'/gtf';

while (<DATA>) {
  chomp;
  my $term  = ucfirst $_;
  my $unzipped = `\\ls $term*.fa 2>/dev/null`;
  my $zipped   = `\\ls $term*.gz 2>/dev/null`;
  chomp $unzipped;
  chomp $zipped;
  print STDERR "Checking to make sure $_ is not done...";
  sleep 1;
  if ($zipped || $unzipped) {
    print STDERR "Oops, found it!\n\n";
    next;
    sleep 5;
  }
  else {
    print STDERR "No, we are good to go!\n\n";
  }
  my $url = URL."/$_/*.gtf.gz";
  system "wget $url";
  system "gunzip *gz";

  chomp(my $file = `\\ls $term*`);
  my $name = basename($file, '.'.RELEASE.'.gtf');

  system "perl -i -pe 's/chloroplast/C/' $file";
  system "perl -i -pe 's/mitochondrion/M/' $file";
  system "perl -i -pe 's/Pt/C/' $file";
  system "perl -i -pe 's/Mt/M/' $file";

  move($file, "$name.gtf");
  print STDERR "DONE $name!\n\n";
}

# update with each release
__DATA__
arabidopsis_lyrata
arabidopsis_thaliana
brachypodium_distachyon
brassica_rapa
chlamydomonas_reinhardtii
cyanidioschyzon_merolae
glycine_max
oryza_glaberrima
oryza_indica
oryza_sativa
physcomitrella_patens
populus_trichocarpa
selaginella_moellendorffii
sorghum_bicolor
vitis_vinifera
zea_mays
