package MyApp::Controller::Info;
use Mojo::Base 'Mojolicious::Controller';
use Mojo::JSON qw(decode_json encode_json);
use File::Slurp;

=head1 info

Show info for pi status and all info server knows about client

=cut

sub landing_page {
  my $self = shift;

  return $self->render(text=>$self->app->route)
}

sub info {
  my $self = shift;
  my $info = encode_json(%{$self->tx->req});
  return $self->render(text=>$info);
}

sub show_pi_status {
  my $self = shift;
  
  return $self->render(text=> read_file('~/tmp/pi-status.txt') );
}

1;
