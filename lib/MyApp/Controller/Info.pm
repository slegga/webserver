package MyApp::Controller::Info;
use Mojo::Base 'Mojolicious::Controller';
use Mojo::JSON qw(decode_json encode_json);
use File::Slurp;

=head1 info

Show info for pi status and all info server knows about client

=cut

sub landing_page {
  my $self = shift;
  return $self->render(text =>'Her kommer index');
  return $self->render(text=>$self->app->route->to_string)
}

sub info {
  my $self = shift;
  my $info = $self->tx->req->headers->to_hash;
;
return $self->render(html=>"<body>$info</body>");
}

sub show_pi_status {
  my $self = shift;
  my $text = read_file('/home/bruker/Dropbox/Apps/pib_stein/pi-status.txt');  
  return $self->render(text => $text );
}

1;
