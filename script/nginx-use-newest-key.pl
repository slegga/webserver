#!/usr/bin/env perl

=head1 NAME

nginx-use-newest-key.pl

=head1 DESCRIPTION

Get newest info about last certificate from certbot.

=cut


use strict;
use warnings;
use Mojo::File 'path';

use File::stat;

my $DIR = '/etc/letsencrypt/keys/';

opendir(my $DH, $DIR)
    or die "Error opening $DIR: $!";

my @files = map { [ stat "$DIR/$_", $_ ] }
                grep( ! /^\d\d\d\d\_key\-certbot.pem/, readdir( $DH ) );

closedir($DH);

sub rev_by_date { $b->[0]->ctime <=> $a->[0]->ctime }

my @sorted_files = sort rev_by_date @files;

my @newest = @{$sorted_files[0]};
my $name = pop(@newest);
print "Name: $name\n";
my $nginxconf = path('/etc/nginx/nginx.conf')->slurp;

$nginxconf =~ s/\d\d\d\d\\_key\-certbot.pem/$name/gm;

path('/etc/nginx/nginx.conf')->spew($nginxconf);

=head1 AUTHOUR

Stein Hammer

=cut
