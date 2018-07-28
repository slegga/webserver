package MyApp::Model::Info;
use Mojo::Base -base;
use Mojo::JSON qw(decode_json encode_json);
use File::Slurp;
use Data::Dumper;

=head1 NAME

MyApp::Model::Info

=head1 DESCRIPTION

Return requested data as hash

Show info for pi status and all info server knows about client

=head1 METHODS

=cut



sub get_request_info_hr {
  my $self = shift;
  my $c =shift;
  my $hash = $c->tx->req->headers->to_hash;
  $hash->{remote_address} = $c->tx->remote_address;
  $hash->{original_remote_address} = $c->tx->original_remote_address;

  return $hash;
}

sub get_pi_status_hr {
  my $self = shift;
  my $c = shift;
  my $file = $c->config->{'pi-status-file'};

  my $text='{}';
  $text = read_file($file) if -f $file;
  warn "QQQQ: ".$text;
  $c->log(info=>$text);
  my $hash = decode_json($text);
  return $hash;
}


1;
