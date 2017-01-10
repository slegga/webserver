package MyApp;
use Mojo::Base 'Mojolicious';
use Mojolicious::Plugins;
#use Mojolicious::Plugin::AccessLog;

=head1 TESTING

  

=cut

my $plugins = Mojolicious::Plugins->new;
$plugins->namespaces( ['MyApp::Plugin']);
use MyApp::Model::Users;
sub startup {
  my $self = shift;
  my $config = $self->plugin('Mojolicious::Plugin::Config' => {file => '../myapp.conf'});
  $self->plugin('Mojolicious::Plugin::AccessLog' => {log => $config->{'accesslogfile'},
    format => ' %h %u %{%c}t "%r" %>s %b "%{Referer}i" "%{User-Agent}i"'});
#  $self->paths(['/home/stein/git/pi-webserver/static']);
  push @{$self->static->paths}, $self->home->rel_dir('static');
  $self->plugin('MyApp::Plugin::Logger');
  $self->secrets($config->{secrets});
  $self->helper(users => sub { state $users = MyApp::Model::Users->new });
 
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
