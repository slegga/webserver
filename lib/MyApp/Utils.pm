package MyApp::Utils;

use Mojo::Base -strict;
use Exporter 'import';
our @EXPORT_OK = qw(cr2br);

=head1 NAME

MyApp::Utils - common webutilities

=head1 SYNOPSIS

    use MyApp::Utils;
    say MyApp::Utils::cr2br('some text.
    Which is breaking');

=head1 DESCRIPTION

Utility class for webservers.

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
