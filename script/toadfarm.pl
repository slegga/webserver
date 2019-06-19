#!/usr/bin/env perl

use Toadfarm -init;
use lib "../utilities-perl/lib";
use SH::UseLib;

=head1 NAME

toadfarm.pl - Master webserver scripts

=cut

my $datestring = localtime();
print "------------------------------\n";
print "Started: $datestring\n";

logging {
        combined => 1,
        file     => "/var/log/toadfarm/pi-webserver.log",
        level    => "info",
};
# TODO Must fix conf file first. Try on liveserver
mount 'API::PiData' => {mount_point => '/api/pi'};
mount 'API::Piano' => {mount_point => '/api/piano'};
mount "MyApp";

plugin "Toadfarm::Plugin::AccessLog";

my @chars = ("A".."Z", "a".."z");

# May unvalidate all connections
my $string;
$string .= $chars[rand @chars] for 1..64;
secrets ( $string );

start ['http://*:8888'], workers => 1;

