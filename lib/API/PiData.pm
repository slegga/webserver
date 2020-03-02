package API::PiData;
use Mojo::Base "Mojolicious";

use Mojo::File 'path';
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
use Model::GetCommonConfig;

=head1 NAME

API::PiData - For getting data from hjernen

=head1 ATTRIBUTES

=cut

has 'config';

=head1 METHODS

=head2 startup

Main for receive data from pi to hjernen.

=cut

sub startup {
	my $app = shift;
	my $gcc = Model::GetCommonConfig->new;
	$app->config($gcc->get_mojoapp_config($0));
	$app->config->{hypnotoad} = $gcc->get_hypnotoad_config($0);
#	$app->plugin(Config => $config);

	$app->plugin("OpenAPI" => {url => $app->home->rel_file("def/pi-data.yaml")});

}

1;
