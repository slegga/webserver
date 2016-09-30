package MyApp::Plugin::Logf;

=head1 NAME

MyApp::Plugin::Logf - Common logging

=head1 DESCRIPTION

=head1 SYNOPSIS

  plugin 'Nx::WWW::Plugin::Logf';

  get '/path' => sub {
    my $self = shift;
    $self->log->info('Hey!');
  };

=cut

use Mojo::Base 'Mojolicious::Plugin';
use Mojo::Log;


=head1 METHODS

=head2 register

See L</SYNOPSIS>.

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
