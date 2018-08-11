package MyApp::Utils;

use Exporter 'import';
@EXPORT_OK = qw(cr2br);

=head1 NAME

MyApp::Utils - common webutilities

=cut

#format text for html
sub cr2br {
  my $text=shift;
  $text =~ s/\n/<BR>/g;
  return $text;
}
1
