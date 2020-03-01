#!/usr/bin/env perl

#!/usr/bin/env perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../utilities-perl/lib";
use SH::UseLib;

# BEGIN { unshift @INC, "$FindBin::Bin/../lib" }
use Mojolicious::Commands;

=head1 NAME

web-login.pl - Master login. The main webserver script.

=cut

# Start command line interface for application
Mojolicious::Commands->start_app('API::PiData');

