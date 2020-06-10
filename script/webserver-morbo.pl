#!/usr/bin/env perl
use Mojolicious::Commands;
use Mojo::File 'path';
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
$ENV{COMMON_CONFIG_DIR}='t/etc';
$ENV{TEST_INSECURE_COOKIES} = 0;
$ENV{NO_SECURITY} = 1;
use lib $lib;
use SH::UseLib;
Mojolicious::Commands->start_app(MyApp => @ARGV);