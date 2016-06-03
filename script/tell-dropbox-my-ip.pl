#!/usr/bin/env perl

=head1 NAME

tell-dropbox-my-ip.pl

=head1 DESCRIPTION

It is goiing to be a personal server. So only I need to know the IP.

The plan:
Look up ip
http://ip-api.com/json/
Lookup pi temparure: /opt/vc/bin/vcgencmd measure_temp
Store date.
Store in given catalog. Check dropbox status, dropbox start dropbox stop.


=cut
use Mojo::Base -strict;
use Mojo :: UserAgent;
# http://mojolicious.org/perldoc/Mojolicious/Guides/Growing
#
my $ua = Mojo::UserAgent->new;
$ua->max_redirects(5);
my $value = $ua->gett('http://ip-api.com/json/') ->res->json;
