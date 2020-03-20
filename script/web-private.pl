#!/usr/bin/env perl

use strict;
use warnings;
use Mojolicious;
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
use lib $lib;
use SH::UseLib;

use Mojolicious::Lite;
use Model::GetCommonConfig;
my $cfg = Model::GetCommonConfig->new->get_mojoapp_config($0);
app->routes->route($cfg->{hypnotoad}->{service_path})->detour('MyApp',{secrets=>$cfg->{secrets} });

app->start;

=head1 NAME

web-login.pl - Master login. The main webserver script.

=cut

# Start command line interface for application
#Mojolicious::Commands->start_app('MyApp');

