package API::PiData;
use Mojo::Base "Mojolicious";
use Data::Dumper;
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
use Model::GetCommonConfig;

=head1 NAME

API::PiData - For getting data from hjernen

=head1 ATTRIBUTES

=cut


=head1 METHODS

=head2 startup

Main for receive data from pi to hjernen.

=cut

sub startup {
	my $app = shift;
	my $gcc = Model::GetCommonConfig->new;
	my $config = $gcc->get_mojoapp_config($0);
	$config->{hypnotoad} = $gcc->get_hypnotoad_config($0);
	my $config_file = path('/tmp/test-webserver.conf');#Mojo::File->tempfile(DIR => '/tmp');
	$config_file->spurt(dumper $config);

	$app->plugin(Config => {file=>"$config_file"});

	$app->plugin("OpenAPI" => {url => $app->home->rel_file("def/pi-data.yaml")});

}

1;
