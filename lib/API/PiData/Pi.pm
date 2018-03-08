package API::PiData::Pi;
use Mojo::Base "Mojolicious::Controller";
use YAML 'Dump';
use autodie;
use Mojo::JSON;

sub _check_client_ip {
# TODO
# get array og Net::IP from config
my $c= shift;
my @isp_ipaddresses_text = $c->config->{isp_ip_range};
# Use Net::IP ip_is_overlap to auth if


}

sub set_pi_data {

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
	warn Dump $c->config;
	my $pi_file = $c->config->{'datadir'} ? $c->config->{'datadir'}.'/pi-status.json' : $ENV{HOME}.'/etc/pi-status.json';
	open my $fh,'>', $pi_file;
	print $fh Mojo::JSON::to_json($body);
	close $fh;
  # $output will be validated by the OpenAPI spec before rendered
  $c->render(openapi => 'ok');
}

1;
