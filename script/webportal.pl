#!/usr/bin/env perl

#!/usr/bin/env perl

use strict;
use warnings;

use FindBin;
BEGIN { unshift @INC, "$FindBin::Bin/../lib" }
use Mojolicious::Commands;

=head1 NAME

web-portal.pl - Master MyApp. The main webserver script.

=cut

# Start command line interface for application
Mojolicious::Commands->start_app('MyApp');

