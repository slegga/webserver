#!/usr/bin/env perl

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
    $lib =  $gitdir->child('utilities-perl','lib')->to_string;
};
use lib $lib;
use SH::UseLib;
use SH::ScriptX;
use Mojo::Base 'SH::ScriptX';
use Mojo::JSON 'decode_json';
use Mojo::File 'path';
use DateTime;
use DateTime::Format::MySQL;
use open qw(:std :utf8);
use YAML::Syck;

use  YAML::Tiny;

#use Carp::Always;

=encoding utf8

=head1 NAME

uptime-pi-alert.pl - Tell to stdout if long time since heard from pi.

=head1 DESCRIPTION

Print if PI has not updated  data in the last

=head1 ATTRIBUTES

=head2 configfile - default to $CONFIG_DIR then $HOME/etc/<<scriptname>>.yml

=cut

has configfile =>($ENV{CONFIG_DIR}||$ENV{HOME}.'/etc').'/mojoapp.yml';
has config => sub { YAML::Syck::LoadFile(shift->configfile) };
option 'dryrun!', 'Print to screen instead of doing changes';

sub main {
    my $self = shift;
    my @e = @{ $self->extra_options };
    my $file = $self->config->{web_services}->{'web-myapp'}->{'pi-status-file'};
    $file =~ s|\$\{HOME\}|$ENV{HOME}|;
    say $file;
    my $time = decode_json(path($file)->slurp)->{a_time};
#    say STDERR $time;
    my $last_pi_epoch=DateTime::Format::MySQL->parse_datetime( $time )->epoch;

# 2003-01"$last_pi_epoch";
    if ($last_pi_epoch < time - 2 * 60 * 60) {
        say "Pi down. Last call at $time";
    }
    say $last_pi_epoch,'  ',time - 2 *60*60;
}

__PACKAGE__->new(options_cfg=>{extra=>1})->main();
