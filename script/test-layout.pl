#!/usr/bin/env perl
#
use Mojolicious::Lite;

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
