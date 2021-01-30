package MyApp::Plugin::Logger;
use Mojo::Base 'Mojolicious::Plugin';
use Mojo::Log;

=head1 NAME

MyApp::Plugin::Logf - Common logging

=head1 SYNOPSIS

  use Mojolicious::Lite;
  plugin 'Mojolicious::Plugin::Logf';

  get '/path' => sub {
    my $self = shift;
    $self->log->info('Hey!');
  };

=head1 DESCRIPTION

Plugin for logging.

=head1 METHODS

=head2 register

See L</SYNOPSIS>.

Environment variabel LOG_LEVEL adjust which log level to use. See Mojo::Log for optionns.

=cut

sub register {
  my($self, $app, $config) = @_;

  if(my $tmp = $app->config->{log}) {
    $config->{$_} = $tmp->{$_} for keys %$tmp;
  }

  if($ENV{LOG_LEVEL}) {
    $config->{level} = $ENV{LOG_LEVEL};
  }

  my $log = Mojo::Log->new(%$config);

  $app->helper(log => sub {
    return $log;
  });
}

1;
