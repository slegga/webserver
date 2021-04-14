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
use Mojo::Date;


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
    die "Missing MyApp:pi-status-file" . Dump $self->config->{web_services} if ! $file;
    $file =~ s|\$\{HOME\}|$ENV{HOME}|;
    say $file;
    my $time = decode_json(path($file)->slurp)->{a_time};
#    say STDERR $time;
    my $last_pi_epoch=Mojo::Date->new($time )->epoch;

    my $old_epoch = time - 11 * 60 * 60; # 6 hour downtime at night
    if ($last_pi_epoch < $old_epoch) {
        say "Pi down. Last call at $time";
    }
    say $last_pi_epoch,'  ', $old_epoch;
}

__PACKAGE__->new(options_cfg=>{extra=>1})->main();
