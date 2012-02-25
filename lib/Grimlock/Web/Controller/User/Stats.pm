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

has 'chart' => (
  is => 'ro',
  required => 1,
  lazy => 1,
  default => sub { Chart::Clicker->new }
);

sub BUILD {
  my $self = shift;
  $self->chart;
}

sub index : Chained('load_user') PathPart('') Args(0) ActionClass('REST') {}

sub index_GET {
  my ( $self, $c ) = @_;
  my $user = $c->stash->{'user'};
  my $chart = $self->chart;
  my $serires = Chart::Clicker::Data::Series->new(
    keys => $user->build_graph_run,
    values => $user->get_all_entry_dates
}

__PACKAGE__->meta->make_immutable;
1;
