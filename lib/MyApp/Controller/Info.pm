package MyApp::Controller::Info;
use MyApp::Utils qw (cr2br);
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
  my $info = $self->tx->req->headers->to_string; #to_hash
#  $info= cr2br($info);

  return $self->render(html=>"<body>$info</body>");
}

sub show_pi_status {
  my $self = shift;
  my $file = $self->config->{'pi-status-file'};
  return $self->render(text => $file);
  my $text = read_file($file);  
#  warn $text;
#  $text = cr2br($text);
  return $self->render(html => $text );
}


1;
