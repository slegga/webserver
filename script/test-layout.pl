#!/usr/bin/env perl
#
use Mojolicious::Lite;

=head1 NAME

test-layout.pl - Test layouts

=cut

get '/with_layout';

app->start;
__DATA__

@@ with_layout.html.ep
% title 'Green';
% layout 'green';
Hello World!

@@ layouts/green.html.ep
<!DOCTYPE html>
<html>
  <head><title><%= title %></title></head>
  <body><%= content %></body>
</html>
