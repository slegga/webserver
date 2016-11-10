package MyApp::Controller::Info;
use Mojo::Base 'Mojolicious::Controller';
use Mojo::JSON qw(decode_json encode_json);
use HTML::TextToHTML;
use File::Slurp;

=head1 info

Show info for pi status and all info server knows about client

=cut

# create a new object
my $conv = new HTML::TextToHTML();

sub landing_page {
  my $self = shift;
  $self->stash(pagecontent => 'Her kommer det tekst');
  $self->stash(pageobj => '/include/basic');
  return $self->render(template => '/commons/pagecontent');
}

sub info {
  my $self = shift;
  my $hash = $self->tx->req->headers->to_hash;
#  my $html = $conv->process_chunk($text);

  return $self->render('commons/dump_hash', myhash => $hash );
}

sub show_pi_status {
  my $self = shift;
  my $file = $self->config->{'pi-status-file'};
  my $text = read_file($file);  
  my $html = $conv->process_chunk($text);
  warn $html;

  return $self->render('commons/include_html', myhtml => $html );
}


1;
