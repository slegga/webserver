package API::PiData;
use Mojo::Base "Mojolicious";

sub startup {
  my $app = shift;
  $app->plugin("OpenAPI" => {url => $app->home->rel_file("def/pi-data.json")});
}

1;
