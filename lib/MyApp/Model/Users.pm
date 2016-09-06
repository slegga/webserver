package MyApp::Model::Users;

=head2 How to generate a google authenticator secret

 perl
 $base32_alphabet='ABCDEFGHIJKLMNOPQRSTUVWXYZ234567';
 print substr($base32_alphabet,rand(32),1) for (0..16);
 print "\n";

=cut 

use strict;
use warnings;
use Authen::OATH;
use Convert::Base32;
use YAML::Tiny;
use Mojo::Log;
use FindBin;

# Log to STDERR
my $log = Mojo::Log->new;

use Mojo::Util 'secure_compare';

my $USERS;
my $userfile = "$FindBin::Bin/../../../etc/users.yml";
if (-r $userfile ) {
    my $tmp = YAML::Tiny->read( $userfile );
    $USERS = $tmp->[0]->{users};
} else {
    $USERS = {
          marcus    => {type=>'password',secret=>'lulz'},
          sebastian => {type=>'password',secret=>'secr3t'},
          foo       => {type=>,'google' ,secret=>"3RZHGD2DLIMBT4C3GLFDG"},
    };
}
warn $USERS;
$log->warn( $USERS );


sub new { bless {}, shift }

sub check {
  my ($self, $user, $pass) = @_;

  # Success
 if (my $u =  $USERS->{$user}) {
    if ($u->{type} eq 'password') {
        return 1 if (secure_compare($pass,$u->{secret}));
    } elsif ($u->{type} eq 'google') {
        my $oath = Authen::OATH->new;
        my $correct_otp = $oath->totp(
        decode_base32( $u->{secret}        ));
        print $correct_otp,"\n";
        return 1 if (secure_compare($pass,$correct_otp));
    } else {
        die "Unkown type";
    }
  }
  # Fail
  return undef;
}



1;
