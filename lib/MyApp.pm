package MyApp;
use Mojo::Base 'Mojolicious';
 
use MyApp::Model::Users;
 
sub startup {
  my $self = shift;
 
  $self->secrets(['5sq/vU1hrBKIheQv5OlFKs4iN5FEamwBt7FrDO1vKw4rG+/XvnhF6KDVArsN7jQ']);
  $self->helper(users => sub { state $users = MyApp::Model::Users->new });
 
  my $r = $self->routes;
  $r->any('/')->to('login#index')->name('index');
 
  my $logged_in = $r->under('/')->to('login#logged_in');
  $logged_in->get('/protected')->to('login#protected');
 
  $r->get('/logout')->to('login#logout');
}
 
1;