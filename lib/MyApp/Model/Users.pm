package MyApp::Model::Users;

=head2 How to generate a google authenticator secret

 perl
 $base32_alphabet='ABCDEFGHIJKLMNOPQRSTUVWXYZ234567';
 print substr($base32_alphabet,rand(32),1) for (0..20);
 print "\n";

=cut 

use strict;
use warnings;
use Authen::OATH;
use Convert::Base32;
use YAML::Tiny;
use Mojo::Log;
use FindBin;
use Data::Dumper;
use Encode;

# Log to STDERR
my $log = Mojo::Log->new;

use Mojo::Util 'secure_compare';

my $USERS;
my $userfile = $ENV{CONFIG_DIR}||"$FindBin::Bin/../../../etc";
$userfile .= "/users.yml";
warn $userfile;
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
warn Dumper $USERS;
#$log->warn( $USERS );


sub new { bless {}, shift }

sub check {
  my ($self, $user, $pass) = @_;

  # Success
 if (my $u =  $USERS->{$user}) {
    if ($u->{type} eq 'password') {
        return 1 if (secure_compare($pass,$u->{secret}));
    } elsif ($u->{type} eq 'google') {
        my $oath = Authen::OATH->new;
        my $bytes = decode_base32( "jc65zcs5qlhrqcolrzgx3" );#$u->{secret} );
        my $correct_otp = $oath->totp($bytes);
        $correct_otp=sprintf("%06d",$correct_otp);
        warn $correct_otp,"\n";
        return 1 if (secure_compare($pass,$correct_otp));
    } else {
        die "Unkown type";
    }
  }
  # Fail
  return undef;
}

sub padd5 {
    my $token = shift;
    while (length $token < 6) {
        $token = "0$token";
    }
    return $token;
}

1;
