package MyApp;
use Mojo::Base 'Mojolicious';
use Mojolicious::Plugins;
use MyApp::Model::Info;
use FindBin;


=head1 TESTING

  

=cut

my $plugins = Mojolicious::Plugins->new;
$plugins->namespaces( ['MyApp::Plugin']);
use MyApp::Model::Users;
sub startup {
  my $self = shift;
  my $conf_dir = $ENV{MOJO_CONFIG} ? $ENV{MOJO_CONFIG} : $ENV{HOME}.'/etc';
  my $conf_file = $conf_dir.'/myapp.conf';
  die "Missing config file: ".$conf_file if !-f $conf_file;
  my $config = $self->plugin('Mojolicious::Plugin::Config' => {file => $conf_file});
  $self->plugin('Mojolicious::Plugin::AccessLog' => {log => $config->{'accesslogfile'},
    format => ' %h %u %{%c}t "%r" %>s %b "%{Referer}i" "%{User-Agent}i"'});
  push @{$self->static->paths}, $self->home->rel_file('static');
  $self->plugin('MyApp::Plugin::Logger');
  $self->plugin('Mojolicious::Plugin::RemoteAddr');
  $self->secrets($config->{secrets});
  $self->helper(users  => sub { state $users = MyApp::Model::Users->new });
  $self->helper(inform =>  sub { state $info = MyApp::Model::Info->new });
 
  my $r = $self->routes;
  $r->any('/login')->to('login#login')->name('login');
  $r->get('/logout')->to('login#logout');
  my $logged_in = $r->under('/')->to('login#logged_in');
  $logged_in->get('/protected')->to('login#protected');
  $logged_in->any('/')->to('login#protected')->name('protected');
  $logged_in->any('/index')->to('info#landing_page');
 
  $logged_in->any('/info')->to('info#info');
  $logged_in->any('/pi-status')->to('info#show_pi_status');

  $logged_in->any('/bootstrap' => sub {  my $c = shift;
    $c->reply->static('bootstrap.html');
  });
#  $self->helper(conf => sub {return $config});
}
 
1;
