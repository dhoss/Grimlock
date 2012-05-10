package Grimlock::Web::Controller::Category;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Grimlock::Web::Controller::API'; }

=head1 NAME

Grimlock::Web::Controller::Category - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

sub base : Chained('/api/base') PathPart('') CaptureArgs(0) {}

sub load_category : Chained('base') PathPart('category') CaptureArgs(1) {
  my ( $self, $c, $category ) = @_;
  my $cat = $c->model('Database::Category')->find(
  {
    name => $category
  },
  {
    prefetch => 'entries'
  });

  $c->stash( category => $cat );
}

=head2 index

=cut

sub index :Chained('base') PathPart('') Args(0) ActionClass('REST') {

}

sub index_GET {
  my ( $self, $c ) = @_;
  return $self->status_ok($c,
    entity => {
     categories => [
       $c->model('Database::Category')->search({}, {
         prefetch => 'category_entries',
         select   => [{ 'count' => 'entries.entryid' }],
         group_by => [ 'entries.entryid' ]
       })->all
     ]
    }
  );
}

sub browse : Chained('load_category') PathPart('') Args(0) ActionClass('REST') {
}

sub browse_GET {
  my ( $self, $c ) = @_;
  my $category = $c->stash->{'category'};
  return $self->status_bad_request($c,
    message => "no such category"
  ) unless $category;

  return $self->status_ok($c,
    entity => {
      category => $category
    }
  );

}
=head1 AUTHOR

,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
