use Test::More;
use Test::Mojo;
use FindBin;
 
# Load application class
$ENV{CONFIG_DIR}= $FindBin::Bin . '/etc';
my $t = Test::Mojo->new('MyApp');
$t->ua->max_redirects(1);
 
$t->get_ok('/login')
  ->status_is(200)
  ->element_exists('form input[name="user"]')
  ->element_exists('form input[name="pass"]')
  ->element_exists('form input[type="submit"]');
 
$t->post_ok('/login' => form => {user => 'sebastian', pass => 'secr3t'})
  ->status_is(200)->content_like(qr/Index/); #was Welcome sebastian
 
$t->get_ok('/protected')->status_is(200)->text_like('a' => qr/Index/);

$t->get_ok('/index')->status_is(200);

$t->get_ok('/pi-status')->status_is(200);

$t->get_ok('/info')->status_is(200);
 
$t->get_ok('/logout')->status_is(200)
  ->element_exists('form input[name="user"]')
  ->element_exists('form input[name="pass"]')
  ->element_exists('form input[type="submit"]');
$t->get_ok('/protected')->status_is(200)->content_like(qr'Password'); 
done_testing();

