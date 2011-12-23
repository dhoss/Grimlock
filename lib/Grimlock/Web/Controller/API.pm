package Grimlock::Web::Controller::API;

use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller::REST' };

__PACKAGE__->config(
 'default'          => 'text/html',
  map => {
    'text/html'        => [ 'View', 'HTML' ],
    'application/json' => [ 'View', 'JSON' ],
  }
);

sub base : Chained('/') PathPart('') CaptureArgs(0) {}


__PACKAGE__->meta->make_immutable;
1;
