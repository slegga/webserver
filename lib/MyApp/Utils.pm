package MyApp::Utils;

use Exporter 'import';
@EXPORT_OK = qw(cr2br);

=head1 NAME

MyApp::Utils - common webutilities

=head1 FUNCTIONS

=head2 cr2br

Change \n to <BR>

=cut

#format text for html
sub cr2br {
  my $text=shift;
  $text =~ s/\n/<BR>/g;
  return $text;
}
1
