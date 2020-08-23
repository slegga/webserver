package MyApp::Model::Info;
use Mojo::Base -base;
use Mojo::JSON qw(decode_json encode_json);
use File::Slurp;
use Data::Dumper;

=head1 NAME

MyApp::Model::Info - Returns data about info.

=head1 SYNOPSIS

    use MyApp::Model::Info;
    use Data::Dumper;
    my $x = MyApp::Model::Info->new;
    say Dumper $x->get_pi_status_hr($c);

=head1 DESCRIPTION

Return requested data as hash

Show info for pi status and all info server knows about client

=head1 METHODS

=head2 get_request_info_hr

Return request info

=head2 get_pi_status_hr

Return pi status info.

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
	if (! $file) {
		my $con = $c->config;
		die Dumper($con);
	}

	my $text='{}';
	$text = read_file($file) if -f $file;
	$c->log(info=>$text);
	my $hash = decode_json($text);
	return $hash;
}


1;
