#!/usr/bin/perl
use Toadfarm -init;
use FindBin;
BEGIN { unshift @INC, "$FindBin::Bin/../lib" }


mount "MyApp" => {local_port => 8888};
start;
