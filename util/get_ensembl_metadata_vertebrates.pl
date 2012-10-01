#!/usr/bin/perl -w
use strict;

my $version = shift || '67';
my @databases = `mysql -hensembldb.ensembl.org -uanonymous -P5306 -e 'show databases' |grep core_ |grep -v collection |grep $version`;

my $q = <<END;
SELECT meta_key,meta_value from meta
WHERE meta_key = \"provider.name\" OR
meta_key = \"provider.url\" OR
meta_key LIKE \"assembly%\" OR
meta_key = \"genebuild.version\" OR
meta_key = \"genebuild.method\" OR
meta_key = \"species.production_name\" OR
meta_key = \"species.scientific_name\" OR
meta_key = \"species.common_name\" OR
meta_key = \"species.taxonomy_id\" OR
meta_key = \"species.division\" OR
meta_key LIKE  \"schema%\" OR
meta_key = \"species.division\"
END
;


for my $db (@databases) {
    print STDERR $db;
    chomp $db;
    my ($sp) = $db =~ /^([a-z]+_[a-z]+)/;
    $sp = ucfirst $sp;
    open OUT, ">$sp.meta.txt";
    print OUT "database $db\n";
    print OUT "host ensembldb.ensembl.org\n";
    print OUT `mysql -hensembldb.ensembl.org -uanonymous -P5306 $db -e '$q' |grep -v 'depth\\|default\\|mapping\\|meta\\|overlap'`;
    unless (`grep division $sp.meta.txt`) {
	print OUT "species.division\tEnsemblVertebrates\n";
    }
    print OUT "\n";
    close OUT;
}
