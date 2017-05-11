use Test::More;
use Test::Mojo;
use FindBin;
 
# Load application class
$ENV{CONFIG_DIR}= $FindBin::Bin . '/etc';
my $t = Test::Mojo->new('API::PiData');
$t->ua->max_redirects(1);
 

$t->post_ok('/set_pi_ip' => {ip => '1.10.100.101'})
  ->status_is(200)->content_is('"ok"');
done_testing();

