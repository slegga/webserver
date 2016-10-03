package MyApp::Controller::Info;
use Mojo::Base 'Mojolicious::Controller';

=head1 info

Show info for pi status and all info server knows about client

=cut

sub landing_page {
  my $self = shift;

  return $self->render(text=>$self->route})
};

sub info {
  my $self = shift;

  return $self->render(text=>$self->tx-req)
}

sub show_pi_status {
  my $self = shift;
  return $self->reply->static('/stein/Dropbox/Apps/pib_stein/pi-status.txt');
}

1;
