use Mojo::Base -strict;
use Test::More;
use Mojo::File 'path';
use open qw(:std :utf8);

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
    $ENV{CONFIG_DIR}='t/etc';

};
use lib $lib;

use SH::UseLib;
use Test::ScriptX;

# uptime-pi-alert.pl - Tell to stdout if long time since heard from pi.
#t/data/pi-status.json
#'
path('t/data/pi-status.json')->spew('{"a_time":"2020-01-16 23:12:01","address":"1.10.100.101"}');

unlike(path('bin/uptime-pi-alert.pl')->slurp, qr{\<\<[A-Z]+\>\>},'All placeholders are changed');
my $t = Test::ScriptX->new('bin/uptime-pi-alert.pl', debug=>1);
$t->run(help=>1);
$t->stderr_ok->stdout_like(qr{uptime-pi-alert})->stdout_like(qr{uptime});
$DB::single=2;
$t->run;
$t->stderr_ok->stdout_like(qr{Pi down});

done_testing;
