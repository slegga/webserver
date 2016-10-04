package MyApp;
use Mojo::Base 'Mojolicious';
use Mojolicious::Plugins;

my $plugins = Mojolicious::Plugins->new;
$plugins->namespaces( ['MyApp::Plugin']);
use MyApp::Model::Users;
sub startup {
  my $self = shift;
  $self->plugin('Mojolicious::Plugin::Config' => {file => '../myapp.conf'});
  $self->plugin('MyApp::Plugin::Logger');
  $self->secrets(['5sq/vU1hrBKIheQv5OlFKs4iN5FEamwBt7FrDO1vKw4rG+/XvnhF6KDVArsN7jQ']);
  $self->helper(users => sub { state $users = MyApp::Model::Users->new });
 
  my $r = $self->routes;
  $r->any('/login')->to('login#login')->name('login');
  $r->get('/logout')->to('login#logout');
  my $logged_in = $r->under('/')->to('login#logged_in');
  $logged_in->get('/protected')->to('login#protected');
  $logged_in->any('/')->to('login#protected')->name('protected');
  $logged_in->any('/index')->to('info#landing_page');
 
  $logged_in->any('/info')->to('info#info')->name('info');
  $logged_in->any('/pi-status')->to('info#show_pi_status');
}
 
1;
