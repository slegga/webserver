package MyApp;
use Mojo::Base 'Mojolicious';
use Mojolicious::Plugins;
use Mojo::File 'path';
use Mojo::Util 'dumper';

my $lib;
BEGIN {
    my $gitdir = Mojo::File->curfile;
    my @cats = @$gitdir;
    while (my $cd = pop @cats) {
        if ($cd eq 'git') {
            $gitdir = path(@cats,'git');
            last;
        }
    }
    $lib =  $gitdir->child('utilities-perl','lib')->to_string; #return utilities-perl/lib
};

#warn "######".$lib;
use lib $lib;
use SH::UseLib;
use MyApp::Model::Info;

use Model::GetCommonConfig;
use Data::Dumper;

=head1 NAME

MyApp

=head1 DESRIPTION

Main lib for webserver.

=head1 METHODS

=head2 startup

Main loop for Webserver.

=cut



sub startup {
	my $self = shift;
	my $config =  $self->config;

	if ( scalar keys %{$config} < 3 ) {
		say STDERR Dumper $config;
		my $gcc = Model::GetCommonConfig->new;
		$config = $gcc->get_mojoapp_config($0,{debug=>1});

		$self->config($config);
	} else {
		$config = $self->config;
	}
	$self->secrets($config->{secrets});
	$self->log->path($config->{mojo_log_path});
	$self->log->info('(Re)Start server');

	$self->plugin('Mojolicious::Plugin::AccessLog' => {log => $config->{'accesslogfile'},
	  format => ' %h %u %{%c}t "%r" %>s %b "%{Referer}i" "%{User-Agent}i"'});
	push @{$self->static->paths}, $self->home->rel_file('static');
	$self->plugin('MyApp::Plugin::Logger');
	$self->plugin('Mojolicious::Plugin::Security'=>{main_module_name=> __PACKAGE__ });
	$self->plugin(Status => {route => $self->routes->any('/status')} );
	$self->helper(inform =>  sub { state $info = MyApp::Model::Info->new });
	my $spath = $config->{hypnotoad}->{service_path};
	my $logged_in = $self->routes->under("/$spath" => sub {
		my $c = shift;
		return 1 if $c->user;
		return $c->unauthenticated;
		return;
	});
	$logged_in->any('/')->to('info#landing_page');
	$logged_in->any('/index')->to('info#landing_page');

	$logged_in->any('/info')->to('info#info');
	$logged_in->any('/pi-status')->to('info#show_pi_status');

	$logged_in->any('/bootstrap' => sub {  my $c = shift;
	  $c->reply->static('bootstrap.html');
	});

	#do not need because of toadfarm i guess
}

1;
