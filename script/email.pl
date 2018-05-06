#!/usr/bin/env perl
use strict(vars);
use autodie;
use warnings qw( FATAL utf8 );
use Data::Dumper;
use Encode;
use 5.018;
use Net::POP3;
use MIME::Parser;
use YAML::Tiny;
use Readonly;
use Carp;
use utf8;
use Mojolicious::Lite;
use IO::ScalarArray;

# use List::MoreUtils;
use open qw( :encoding(UTF-8) :std );

my $homedir;

BEGIN {
    if ( $^O eq 'MSWin32' ) {
        $homedir = 'c:\privat';
    } else {
        $homedir = $ENV{HOME};
    }
}
# use lib "$homedir/lib";
use lib "$ENV{HOME}/git/utillities-perl/lib";
use SH::Table;

binmode( DATA,   ":encoding(UTF-8)" );
binmode( STDOUT, ":utf8" );

plugin 'PODRenderer';

=encoding utf8

=head1 NAME

email.pl - My own email client

=head1 DESCRIPTION

Under construction.

=cut

# TODO:
# Få laget tabeller og stanadrdisere måter å presentere data
# Vis bare from,to ,cc, subject opsjon fo rå vise alt.

Readonly my $CONFIGFILE => $ENV{HOME} . '/etc/email.yml';
my $config_data;

# my $messages = $pop->list
#     or die "Can't get list of undeleted messages: $!\n";
eval {
    open my $FH, '< :encoding(UTF-8)', $CONFIGFILE or die "Failed to read $CONFIGFILE: $!";
    $config_data = YAML::Tiny::Load(
        do { local $/; <$FH> }
    );    # slurp content
} or do {
    confess $@;
};
Readonly my $USERNAME        => $config_data->{username};
Readonly my $PASSWORD        => $config_data->{password};
Readonly my $MAIL_SERVER     => $config_data->{mail_server};
Readonly my $ATTACHMENT_PATH => "$homedir/Dropbox/data/email/files";
print "Start up Start\n";
$SH::Table::directory = "$homedir/Dropbox/data/email";
my $emailheaders = SH::Table->new( 'email-headers', { utf8 => 1 } );
my $spammers = SH::Table->new('spammers');
print "Start up Tables loaded\n";

my $pop = Net::POP3->new($MAIL_SERVER)
    or die "Can't open connection to $MAIL_SERVER : $!\n";
defined( $pop->login( $USERNAME, $PASSWORD ) )
    or die "Can't authenticate: $!\n";
print "Start up pop ok\n";
my @popstat = $pop->popstat();
my $parser  = new MIME::Parser;
$parser->output_dir($ATTACHMENT_PATH);
print "Start up ok\n";

# die"stopped ok";
# GET NEW EMAILS

# my %msgnums=%{$pop->uidl()};
# print Dumper %msgnums;
# my @msgids= sort {$b <=> $a} grep {ord $_}keys %msgnums;
# print join ("\n",map{$msgnums{$_} } @msgids[0 .. 20]);
#print join ("\n",@msgids[0 .. 20]);

sub getemailheaders($) {
    my $emailheaders_hr = shift;
    my @messages        = ();
    my $msgmax          = $popstat[0];
    print "Start getemailheaders\n";
    my $lastrow = $emailheaders_hr->fetchlastline();

    #    print Dumper $lastrow;
    my $msgmin;
    if ( defined $lastrow ) {
        $msgmin = $lastrow->{msgnum} // 0 + 1;
    } else {
        $msgmin = 1;
    }
    if ( $msgmin < $msgmax ) {
    MESSAGES:
        foreach my $msgid ( $msgmin .. $msgmax ) {
            next if ( $msgid == 372 || $msgid == 373 );
            my $message = $pop->top($msgid);
            unless ( defined $message ) {
                warn "Couldn't fetch $msgid from server: $!\n";
                next;
            }
            my %msgprint;
        LINES:
            for my $line (@$message) {

                if ( $line =~ /^(Date|From|Subject):\s+/i ) {
                    $line = decode( "MIME-Header", $line );
                    next MESSAGES
                        if $line
                        =~ /^From.*(?:samlerhuset|info\@news.groupon.no|noreply\@letsdeal.no|nyhetsbrev1\@dnb.no|noreply\@reiseguiden.no|noreply\@r.grouponmail.no|victoria\@leadphysician.com|noreply\@tv2.no)/;
                    chomp $line;
                    $line =~ s/\s+//;
                    my ( $key, @value ) = split /\:/, $line;
                    $key = lc($key);
                    $msgprint{$key} = join ':', @value;
                    if ( $key eq 'date' ) {
                        $msgprint{$key} =~ s/\w+\,//;
                        $msgprint{$key} =~ s/\s*[++-]\d{4}$//;
                    }
                    if ( $key eq 'from' ) {

                        #$msgprint{$key}=s/\s*?//;
                        if ( $msgprint{$key} !~ m/^\s*\</ ) {
                            $msgprint{$key} =~ s/\<.*\>//;
                        }
                        $msgprint{$key} =~ s/\<(.*)\>/$1/;
                        $msgprint{$key} =~ s/\"(.*)\"/$1/;
                    }
                }
            }
            if ( scalar( keys %msgprint ) == 3 ) {
                print $msgid, "\n";
                $msgprint{'msgnum'} = $msgid;
                $msgprint{'links'}  = '';
                push @messages, \%msgprint;
                $emailheaders_hr->append( \%msgprint );

                #        $emailheaders_hr->commit();
            }
        }
    }
    print "End getemailheaders\n";
    if ( !@messages ) {
        my $last = $#{ $emailheaders_hr->{data} };
        $last -= 10;
        for my $i ( $last .. ( $last + 10 ) ) {
            print "$i\n";
            push @messages, $emailheaders_hr->fetchlinenum($i);
        }
    }
    return \@messages;
}

# MAIN
#getemailheaders($emailheaders);

get '/' => sub {
    my $self = shift;
    my $vear = 'vær';
    $vear = encode( 'utf8', $vear );
    my $menu_ref = { 'epost' => '/epost', $vear => '/vaer' };
    $self->session->{menu_ref} = $menu_ref;

    $self->stash->{'emailheaders'} = getemailheaders($emailheaders);
    $self->render('index');
};

get '/epost' => sub {
    my $self = shift;
    my $vear = 'vær';
    $vear = encode( 'utf8', $vear );

    #    my $menu_ref = {'epost' => '/epost',$vear => '/vaaer'};
    #    $self->session->{menu_ref}=$menu_ref;
    my $menu_ref = { 'epost' => '/epost', $vear => '/vaer' };
    $self->session->{menu_ref} = $menu_ref;

    $self->stash->{'emailheaders'} = getemailheaders($emailheaders);
    print Dumper $self->stash->{'emailheaders'};
    $self->stash->{'email'}  = undef;
    $self->stash->{'msgnum'} = undef;
    $self->render('epost');
};

get '/epost/enkel/:msgnum' => sub {
    my $self   = shift;
    my $vear   = 'vær';
    my $msgnum = $self->param('msgnum');
    $vear = encode( 'utf8', $vear );

    my $email_ar = $pop->get($msgnum);
 #   my $AH       = new IO::ScalarArray $email_ar;
#    my $entity   = $parser->parse($AH) || die "couldn't parse MIME stream";

    my $head    = "";#$entity->head;
    my $content = $head->as_string . "\n";

    my @parts = "";#$entity->parts;
    my $body  = "";#$entity->bodyhandle;

    if ( defined $body ) {
        $content .= $body->as_string . "\n";

        # my $filename = $body->path;
        # unlink($filename);
        print "Content: " . $content;
    }
    my $part;
    for $part (@parts) {
        next if !$part->bodyhandle;
        my $path = $part->bodyhandle->path;
        my $file = $path;
        $file =~ s/$ATTACHMENT_PATH//o;
        if ( $file =~ /msg\-\d.*\.txt/ ) {
            unlink($path);
        } elsif ( $file =~ /msg\-\d.*\.html/ ) {
            open my $FH, '< :encoding(UTF-8)', $path;
            $content .= join( '', <$FH> );
        } else {
            $content .= "\n<br/>Saved attachment: $file<cr/>";
        }
    }

    $self->stash->{'emailheaders'} = getemailheaders($emailheaders);
    $self->stash->{'msgnum'}       = $msgnum;
    $self->stash->{'email'}        = $content;
    $self->render('epost');
};

get '/vaer' => sub {
    my $self = shift;

    #    my $vear='vær';
    #    $vear=encode('utf8',$vear);
    #    my $menu_ref = {'epost' => '/epost',$vear => '/vaaer'};
    #    $self->session->{menu_ref}=$menu_ref;

    #$self->stash->{'emailheaders'} = getemailheaders();
    $self->render('vaer');
};

app->secrets(['My very secret passphrase.']);
app->start;

=head1 AUTHOR

Stein Hammer

=cut

__DATA__
@@ index.html.ep
% title 'Enkel oversikt';
% layout 'default';
<br/>
<table class="list">
    <tr>
    % for my $column_name ( qw /date from subject/ ) {
    <th><%= uc $column_name %></th>
    % }
    </tr>
    %# % if ($arr_ref) {
        % for my $r (reverse 0..$#$emailheaders ) {
            <tr>
            % for my $c (qw /date from subject/ ) {
                <td>
                    <%= $emailheaders->[$r]->{$c} %>
                </td>
            % }
        % }
    %# }
    </tr>
</table>
</br>

@@ epost.html.ep
% title 'Epost';
% layout 'default';
<br/>
<table class="list">
  %#  <tr>
  %#  % for my $column_name ( qw{date from subject} ) {
  %#  <th><%= uc $column_name %></th>
  %#  % }
  %#  </tr>
    % if ref $emailheaders ne 'ARRAY' {
        alarm('$emailheaders not array')
    % }

    % for my $r (0..$#$emailheaders ) {
    % if ref $r ne 'HASH' {
        alarm('$r not hash<%=ref $r %>')
    % }
        %# if (defined $msgnum && $emailheaders->[$r]->{'msgnum'} == $msgnum) {
         #   <tr id='<%= $r %>' bgcolor="#FF0000">
        %#  } else {
            <tr id='<%= $r %>'>
        %# }

        % for my $c (qw /date from subject/ ) {
            <td>
                <li><%= link_to $emailheaders->[$r]->{$c}, '/epost/enkel/'.$emailheaders->[$r]->{'msgnum'} %>
                </li>
            </td>
        % }
    % }
    </tr>
</table>
</br>
% if ($msgnum) {
    %== $email
% }
<html>

@@ vaer.html.ep
% title 'Vær';
% layout 'default';
<br/>
<img id="imgMeteogram" width="828" height="272" style="margin-top: -0px; margin-left: -6px;" alt="Meteogrammet: Oslo" src="http://www.yr.no/sted/Norge/Oslo/Oslo/Oslo/meteogram.png"></img>


@@ layouts/default.html.ep
<!doctype html><html>
<head>
<link href="/myown.css" rel="stylesheet" type="text/css">
</head>
% my $menu_ref = session 'menu_ref';
% for my $key(keys %$menu_ref) {
    <%= link_to $key => $menu_ref->{$key} %>
% }
<h1><%= title %></h1>
<body><%= content %></body>
</html>


