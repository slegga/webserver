#!/usr/bin/env perl

use Toadfarm -init;
use Mojo::File 'path';
use Mojo::Util 'dumper';
my $lib;
BEGIN {
    my $gitdir = Mojo::File->curfile;
    my @cats = @$gitdir;
    while (my $cd = pop @cats) {
        if ($cd eq 'git') {
            $gitdir = path(@cats,'git');
            last;
        }
    }
    $lib =  $gitdir->child('utilities-perl','lib')->to_string; #return utilities-perl/lib
};
use lib $lib;
use SH::UseLib;

=head1 NAME

toadfarm.pl - Master webserver scripts

=cut

my $datestring = localtime();
print "------------------------------\n";
print "Started: $datestring\n";

$ENV{MOJO_MODE}='development';
logging {
        combined => 1,
        file     => "/var/log/toadfarm/pi-webserver.log",
        level    => "info",
};
# TODO Must fix conf file first. Try on liveserver
mount 'SH::PiOpenAPI' => {mount_point => '/api/home/'};
mount 'API::Piano' => {mount_point => '/api/piano/'};
my $priv = '/privat/';
mount "MyApp" => {mount_point => $priv};

plugin 'Mojolicious::Plugin::AccessLog' => {format=>'%{%Y-%m-%d %T}t %h %{identity}e %r %s %T '};

my @chars = ("A".."Z", "a".."z");

# May unvalidate all connections
my $string;
$string .= $chars[rand @chars] for 1..64;
secrets ( $string );

start ['http://*:8888'], workers => 1, proxy =>$priv;
