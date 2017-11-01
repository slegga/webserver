#!/usr/bin/env perl
use Toadfarm -init;
use FindBin;
BEGIN { unshift @INC, "$FindBin::Bin/../lib" }

my $datestring = localtime();
print "------------------------------\n";
print "Started: $datestring\n";

logging {
        combined => 1,
        file     => "/var/log/toadfarm/pi-webserver.log",
        level    => "info",
};
# TODO Must fix conf file first. Try on liveserver
mount 'API::PiData' => {mount_point => '/api'};
mount "MyApp";

plugin "Toadfarm::Plugin::AccessLog";

my @chars = ("A".."Z", "a".."z");

# May unvalidate all connections
my $string;
$string .= $chars[rand @chars] for 1..64;
secrets ( $string ); 

start ['http://*:8888'], workers => 1;

