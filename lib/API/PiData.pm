package API::PiData;
use Mojo::Base "Mojolicious";

=head1 NAME

API::PiData - For getting data from hjernen

=cut

sub startup {
  my $app = shift;
  my $conf_file = $ENV{MOJO_CONFIG} ? $ENV{MOJO_CONFIG} : $ENV{HOME}.'/etc/api.conf';
  $app->plugin("OpenAPI" => {url => $app->home->rel_file("def/pi-data.yaml")});
  $app->plugin('Config'=>{file => $conf_file});
}

1;
