package Grimlock::Web::Controller::User::Stats;

use Chart::Clicker;
use Chart::Clicker::Context;
use Chart::Clicker::Data::DataSet;
use Chart::Clicker::Data::Marker;
use Chart::Clicker::Data::Series;
use Geometry::Primitive::Rectangle;
use Graphics::Color::RGB;
use Geometry::Primitive::Circle;
use Moose;
use namespace::autoclean;
use Try::Tiny;

BEGIN { extends 'Grimlock::Web::Controller::User' };

sub index : Chained('load_user') PathPart('') Args(0) ActionClass('REST') {}

sub index_GET {
  my ( $self, $c ) = @_;
}

__PACKAGE__->meta->make_immutable;
1;
