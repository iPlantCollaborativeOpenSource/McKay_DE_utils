#!/usr/bin/perl -w
use strict;

my $version = shift || '14_67';
my @databases = `mysql -uanonymous -P4157 -hmysql.ebi.ac.uk -e 'show databases' |grep core |grep -v collection |grep $version`;

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
meta_key = \"species.taxonomy_id\"
END
;


for my $db (@databases) {
    print STDERR $db;
    chomp $db;
    my ($sp) = $db =~ /^([a-z]+_[a-z]+)/;
    $sp = ucfirst $sp;
    open OUT, ">$sp.meta.txt";
    print OUT "database $db\n";
    print OUT "host mysql.ebi.ac.uk\n";
    print OUT `mysql -uanonymous -P4157 -hmysql.ebi.ac.uk $db -e '$q' |grep -v 'depth\\|default\\|mapping\\|meta\\|overlap'`;
    print OUT "\n";
    close OUT;
}
