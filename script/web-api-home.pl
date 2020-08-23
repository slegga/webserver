#!/usr/bin/env perl

#!/usr/bin/env perl

use strict;
use warnings;
use Mojolicious::Commands;
use Mojo::File 'path';

my $lib;
BEGIN {
    my $gitdir = Mojo::File->curfile;
    my @cats = @$gitdir;
    while (my $cd = pop @cats) {
        if ($cd eq 'git') {
            $gitdir = path(@cats,'git');
            last;
        }
    }
    $lib =  $gitdir->child('utilities-perl','lib')->to_string;
};
use lib $lib;

use SH::UseLib;

# BEGIN { unshift @INC, "$FindBin::Bin/../lib" }

=head1 NAME

web-api-home.pl - API for get data from home server.

=head1 DESCRIPTION

Not in use. Maybe in the fuure for exporting emails to piano.

=cut

# Start command line interface for application
Mojolicious::Commands->start_app('API::PiData');

