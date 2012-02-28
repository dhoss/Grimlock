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
use Data::Dumper;
use namespace::autoclean;
use Try::Tiny;
use Data::Dumper;

BEGIN { extends 'Catalyst::Controller' };

has 'chart' => (
  is => 'ro',
  required => 1,
  lazy => 1,
  default => sub { 
    Chart::Clicker->new( format => 'png', height => '200', width => '250' ) 
  }
);

sub BUILD {
  my $self = shift;
  $self->chart;
}

sub index : Chained('../load_user') PathPart('stats') Args(0) {
  my ( $self, $c ) = @_;
  my $user = $c->stash->{'user'};
  # this should all go in its own model
  my $chart = $self->chart;
  my $chart_config = $c->config->{'charts'}{'user_stats'};
  $chart->height( ($chart_config->{'height'} || 300 ) );
  $chart->width( ( $chart_config->{'width'}  || 500 ) );
  my $series = Chart::Clicker::Data::Series->new(
    keys   => $user->build_graph_range,
    values => $user->build_graph_domain
  );
  my $dataset = Chart::Clicker::Data::DataSet->new(
    series => [ $series ]
  );
  $chart->add_to_datasets($dataset);
  $c->stash(
    graphics_primitive => $chart,
  );
  $c->forward('View::Graphics');
}

__PACKAGE__->meta->make_immutable;
1;
