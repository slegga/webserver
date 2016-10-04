package MyApp::Controller::Info;
use Mojo::Base 'Mojolicious::Controller';
use Mojo::JSON qw(decode_json encode_json);
use File::Slurp;

=head1 info

Show info for pi status and all info server knows about client

=cut

sub landing_page {
  my $self = shift;

  return $self->render(text=>$self->app->route->to_string)
}

sub info {
  my $self = shift;
  my $info = $self->tx->req->text;
  return $self->render(text=>$info);
}

sub show_pi_status {
  my $self = shift;
  
  return $self->render(text=> read_file('/home/stein/tmp/pi-status.txt') );
}

1;
