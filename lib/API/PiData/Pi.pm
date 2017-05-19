package API::PiData::Pi;
use Mojo::Base "Mojolicious::Controller";
use YAML 'Dump';
use autodie;
sub set_ip {

  # Do not continue on invalid input and render a default 400
  # error document.
  my $c = shift->openapi->valid_input or return;

  # IP check goes here
  my $spec = $c->openapi->spec;
#  unless ($spec->{'x-opening-hour'} == (localtime)[2]) {
#    return $c->render(openapi => [], status => 498);
#  }

  # $c->openapi->valid_input copies valid data to validation object,
  # and the normal Mojolicious api works as well.
  my $body = $c->validation->output->{body};
  my $pi_ip   = $body->{ip};
  warn Dump $c->config;
  my $pi_ip_file = $c->config->{'datadir'} ? $c->config->{'datadir'}.'/pi-ip.txt' : $ENV{HOME}.'/etc/pi-ip.txt';
  warn $pi_ip_file;
	open my $fh,'>', $pi_ip_file;
	print $fh $pi_ip;
	close $fh;
  # $output will be validated by the OpenAPI spec before rendered
  $c->render(openapi => 'ok');
}

1;
