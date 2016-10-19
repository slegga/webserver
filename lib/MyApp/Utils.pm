package MyApp::Utils;

use Exporter 'import';

@EXPORT_OK = qw(cr2br);

#format text for html
sub cr2br {
  my $text=shift;
  $text =~ s/\n/<BR>/g;
  return $text;
}
1
