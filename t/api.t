use Test::More;
use Test::Mojo;
use FindBin;

sub repohomedir {
	return "FindBin::Bin/..";
} 
# Load application class
$ENV{MOJO_CONFIG} = $FindBin::Bin . '/etc/api.conf';
my $t = Test::Mojo->new('API::PiData');
$t->ua->max_redirects(1);
my $ipfile = "$FindBin::Bin/data/pi-ip.txt","IP file is created";

if (-f $ipfile ) {
  unlink($ipfile);
}

$t->post_ok('/set_pi_ip' => json => {ip => '1.10.100.101'})
  ->status_is(200)->content_is('"ok"');
ok(-f "$FindBin::Bin/data/pi-ip.txt","IP file is created");
done_testing();

