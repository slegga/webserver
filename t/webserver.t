use Test::More;
use Test::Mojo;
use Mojo::Base -strict;
use Carp::Always;
use lib '.';
use Data::Dumper;
use Mojo::JWT;

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

use Model::GetCommonConfig;

$ENV{COMMON_CONFIG_DIR} ='t/etc';
$ENV{TEST_INSECURE_COOKIES}=1;

my $db = Mojo::SQLite->new($ENV{COMMON_CONFIG_DIR}.'/session_store.db')->db;
$db->query($_) for split(/\;/, path('t/sql/table_defs.sql')->slurp);
my $user ='admin';
$db->insert('sessions',{sid=>'123', username=>$user, status=>'active'});
# login with jwt

$ENV{COMMON_CONFIG_DIR} ='t/etc';
$ENV{TEST_INSECURE_COOKIES}=1;
$user = 'admin';
my $cfg = Model::GetCommonConfig->new->get_mojoapp_config('web-myapp');
my $spath = $cfg->{hypnotoad}->{service_path};
my $secret = (split(/[\n\s]+/,path($ENV{COMMON_CONFIG_DIR},'secrets.txt')->slurp))[0];
my $jwt = Mojo::JWT->new(claims=>{sid=>'123',expires => time + 60},secret=>$secret)->encode;
my $cookie = Mojo::Cookie::Request->new({name=>'sso-jwt-token',value=>$jwt});
diag "jwt:" . $jwt;
my $t = Test::Mojo->new('MyApp',$cfg);#Mojo::File->new('script/web-private.pl'));
$t->ua->on(start => sub {
	my ($ua, $tx) = @_;
	$tx->req->headers->header('X-Original-URI','http://dilldall.no');
	$tx->req->cookies($cookie);
	});


$t->get_ok("/$spath")->status_is(200)->content_like(qr'Hammer');
$t->content_like(qr'/privat/info')->content_like(qr'/privat/pi-status');
$t->get_ok("/$spath/index")->status_is(200)->content_like(qr'admin');


done_testing;
