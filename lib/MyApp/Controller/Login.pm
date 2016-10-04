package MyApp::Controller::Login;
use Mojo::Base 'Mojolicious::Controller';
use Mojo::Log;
my $log = Mojo::Log->new;


sub login {
  my $self = shift;
  my $user = $self->param('user') || '';
  my $pass = $self->param('pass') || '';

  $self->app->log->info("$user tries to log in");
  if(! $self->users->check($user, $pass) ) {
	$self->app->log->info("$user is NOT logged in");
	return $self->render
  }

  $self->app->log->info("$user is logged in");

  $self->session(user => $user);
 
  $self->flash(message => 'Thanks for logging in.');
  $self->redirect_to('protected');
}

sub logged_in {
  my $self = shift;
  
  return 1 if $self->session('user');
  $self->redirect_to('login');
  return undef;
}

sub logout {
  my $self = shift;
  $self->session(expires => 1);
  $self->redirect_to('login');
}

1;
