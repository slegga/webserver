use Test::More;
use Test::Mojo;
use FindBin;

# Load application class
$ENV{COMMON_CONFIG_DIR} = $FindBin::Bin . '/etc'; # set config dir to gitrepo
my $t = Test::Mojo->new('API::PiData');
$t->ua->max_redirects(1);
my $ipfile = "$FindBin::Bin/data/pi-status.json";

if (-f $ipfile ) {
  unlink($ipfile);
}

$t->post_ok('/pi' => json => {address => '1.10.100.101',a_time=>"2020-01-16 23:12:01"})
  ->status_is(200)->content_is('"ok"');
ok(-f $ipfile, "IP file is created");
done_testing();

