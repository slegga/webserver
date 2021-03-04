package API::PiData::Pi;
use Mojo::Base "Mojolicious::Controller";
# use YAML::Tiny 'Dump';
use autodie;
use Mojo::JSON;
use YAML::Syck;

=head1 NAME

API::PiData::Pi - Receive data about PI server.

=head1 SYNOPSIS

    # Application
    package MyApp;
    use Mojo::Base 'Mojolicious', -signatures;
    use API::PiData::Pi;

    # Route
    sub startup ($self) {
        $self->routes->post('/pidata')->to('PI#set_pi_data');
    }

=head1 DESCRIPTION

This is a controller class. Ment to be dispatched to from mojolicious application class in route definiton.

=head1 METHODS

=head2 set_pi_data

Store pi data to file.

And store history in a csv file.

=cut


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

	# $c->openapi->valid_input copies valid data to validation object,
	# and the normal Mojolicious api works as well.
	my $body = $c->validation->output->{body};
	say STDERR Dump $c->config;
	my $pi_file = $c->config->{'datadir'} ? $c->config->{'datadir'}.'/pi-status.json' : $ENV{HOME}.'/etc/pi-status.json';
    {
    	open my $fh,'>', $pi_file;
    	print $fh Mojo::JSON::to_json($body);
    	close $fh;
    }
	my $pi_history = $c->config->{'datadir'} ? $c->config->{'datadir'}.'/pi-history.csv' : $ENV{HOME}.'/etc/pi-history.csv';

	# write
	{
    	my $temp = $body->{temp};
    	$temp =~ s/\D+$//g;
    	open my $fh,'>>',$pi_history;
    	printf $fh "%s;%s\n",Mojo::Date->new($body->{a_time})->epoch, $temp;
        close $fh;
    }
    $c->render(openapi => 'ok');
}

1;
