#!/usr/bin/env perl

use Mojo::Base -strict;
use Mojo::File 'path';
use lib 'lib';
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
use Model::GetCommonConfig;

use WWW::PODViewer;
use Mojolicious::Commands;

# Start command line interface for application
Mojolicious::Commands->start_app('MyApp');

=head1 NAME

web-myapp.pl - Starter program for webserver

=head1 DESCRIPTION

Starter program nothing else.

=head1 Testing

TEST_USER=stein morbo script/web-myapp.pl

http://127.0.0.1:3000/privat/index