package MyApp::Controller::Info;
use Mojo::Base 'Mojolicious::Controller';
use Mojo::JSON qw(decode_json encode_json);
use HTML::TextToHTML;
use File::Slurp;
use Data::Dumper;
use POSIX 'strftime';

=head1 NAME

MyApp::Controller::Info

=head1 SYNOPSIS

    use Mojo::Base 'Mojolicious';
    sub startup {
        my $self= shift;
    	$self->routes->any('/index')->to('info#landing_page');
    }

=head1 DESCRIPTION

Mojolicious controller class. Show info for pi status and all info server knows about client

=cut

=head1 METHODS

=head2 landing_page

Rener landing page

=cut

# create a new object
my $conv = HTML::TextToHTML->new;


sub landing_page {
  my $self = shift;
  $self->stash(pagecontent => 'Her kommer det tekst');
  $self->stash(pageobj => '/include/basic');
  my $req_hr = $self->inform->get_request_info_hr($self);
  my $pi_status = $self->inform->get_pi_status_hr($self);
  my @now = localtime;
  my @fulldate = split(" ", localtime(time));
  my $week = strftime('%V',@now);
  my $daymonth = strftime('%d',@now);
  my @months = qw/januar februar mars april mai juni juli august september oktober november desember/;
  my %days = ("Mon", "mandag", "Tue", "tirsdag", "Wed", "onsdag", "Thu"
  , "torsdag", "Fri", "Fredag", "Sat", "lørdag", "Sun", "søndag");
  $self->stash({week=>$week, day=>$days{$fulldate[0]}, date=>"$daymonth $months[$now[4]] ".(1900 + $now[5])});
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
