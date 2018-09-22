package MyApp::Controller::Info;
use Mojo::Base 'Mojolicious::Controller';
use Mojo::JSON qw(decode_json encode_json);
use HTML::TextToHTML;
use File::Slurp;
use Data::Dumper;

=head1 NAME

MyApp::Controller::Info

=head1 DESCRIPTION

Show info for pi status and all info server knows about client

=cut

# create a new object
my $conv = new HTML::TextToHTML();


=head2 landing_page

Rener landing page

=cut 

sub landing_page {
  my $self = shift;
  $self->stash(pagecontent => 'Her kommer det tekst');
  $self->stash(pageobj => '/include/basic');
  my $req_hr = $self->inform->get_request_info_hr($self);
  my $pi_status = $self->inform->get_pi_status_hr($self);
  return $self->render(template => 'landing_page');
}

=head2 info

Render info page.

=cut

sub info {
  my $self = shift;

  return $self->render('commons/dump_hash', myhash => $self->inform->get_request_info_hr($self) );
}

=head2 show_pi_status

render pi status page

=cut

sub show_pi_status {
  my $self = shift;
  my $return = $self->inform->get_pi_status_hr($self);
  return $self->render('commons/dump_hash', myhash => $return );
}


1;
