#!/usr/bin/perl -w
use strict;
use constant EMAIL => 'sheldon.mckay@gmail.com'; 
use constant PATH  => '/usr/local2/sheldon/';
use constant USER  => 'smckay';
use constant DEVER =>  31350;
use constant JSON  => <<END;
{"components":[
	       {"name":"NAME ",
		"location":"PATH",
		"type":"executable",
		"description":"DESC",
		"version":"VERSION",
		"attribution":"ATTRIBUTION",
		"implementation":
		{"implementor_email":"EMAIL",
		 "implementor":"USER",
		 "test":
		 {"params":[]}}}
	       ],
 "templates":[],
 "analyses":[]
 }
END
;

my $usage = "./publish_app.pl appname version 'description' 'attribution']\n";

my $name    = shift || die $usage;
my $version = shift || die $usage;
my $desc    = shift || '';
my $attr    = shift || '';
my $json    = JSON;
my $email   = EMAIL;
my $user    = USER;
my $path    = PATH;
my $dever   = DEVER;

# interpolate variables
$json =~ s/NAME/$name/;
$json =~ s/VERSION/$version/;
$json =~ s/DESC/$desc/;
$json =~ s/PATH/$path/;
$json =~ s/EMAIL/$email/;
$json =~ s/USER/$user/;
$json =~ s/ATTRIBUTION/$attr/;

mkdir 'to_be_published' unless -d 'to_be_published';
open J, ">to_be_published/$name.json"|| die $!;


print J $json;

close J;

exit 0;
