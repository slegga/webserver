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
use Model::Users;
use Model::GetCommonConfig;


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
#  my $conf_dir = $ENV{MOJO_CONFIG} ? $ENV{MOJO_CONFIG} : $ENV{HOME}.'/etc';
#  my $conf_file = $conf_dir.'/myapp.conf';
#  die "Missing config file: ".$conf_file if !-f $conf_file;
  my $gcc = Model::GetCommonConfig->new;
  my $config = $gcc->get_mojoapp_config($0);
  $config->{hypnotoad} = $gcc->get_hypnotoad_config($0);
  $self->config($config);
  warn dumper $self->config->{hypnotoad};
  # = $self->plugin('Mojolicious::Plugin::Config' => {file => $conf_file});
  $self->plugin('Mojolicious::Plugin::AccessLog' => {log => $config->{'accesslogfile'},
    format => ' %h %u %{%c}t "%r" %>s %b "%{Referer}i" "%{User-Agent}i"'});
  push @{$self->static->paths}, $self->home->rel_file('static');
  $self->plugin('MyApp::Plugin::Logger');
  $self->plugin(Status => {route => $self->routes->any('/status')} );
#  $self->plugin('Mojolicious::Plugin::RemoteAddr');
  $self->secrets($config->{secrets});
  $self->helper(users  => sub { state $users = MyApp::Model::Users->new });
  $self->helper(inform =>  sub { state $info = MyApp::Model::Info->new });

  my $r = $self->routes;
  my $logged_in = $r->under('/' => sub {1});#disable security ->under('/')->to('login#logged_in');
  $logged_in->get('/protected')->to('login#protected');
  $logged_in->any('/')->to('info#landing_page');
  $logged_in->any('/index')->to('info#landing_page');

  $logged_in->any('/info')->to('info#info');
  $logged_in->any('/pi-status')->to('info#show_pi_status');

  $logged_in->any('/bootstrap' => sub {  my $c = shift;
    $c->reply->static('bootstrap.html');
  });

	#do not need because of toadfarm i guess
	if ( my $path = $self->config->{hypnotoad}->{service_path} ) {
		my @path_parts = grep /\S/, split m{/}, $path;
		$self->hook( before_dispatch => sub {
			my ( $c ) = @_;
			my $url = $c->req->url;
			my $base = $url->base;
			$base->path(@path_parts);
		#	push @{ $base->path }, @path_parts;
			$base->path->trailing_slash(1);
			$url->path->leading_slash(0);
		});
	}
}

1;
