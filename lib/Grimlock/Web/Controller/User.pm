package Grimlock::Web::Controller::User;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Grimlock::Web::Controller::API' };

=head1 NAME

Grimlock::Web::Controller::User - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index : Path Args(0) {
  my ( $self, $c ) = @_;
  $c->res->redirect(
    $c->uri_for_action('/user/list')
  );
};

sub list : Chained('/api/base') PathPart('users') Args(0) ActionClass('REST'){
  my ( $self, $c ) = @_;
}

sub list_GET {
  my ( $self, $c ) = @_;
  $self->status_ok($c,
    entity => {
      users => [ $c->model('Database::User')->all ]
    },
  );
}

sub login  : Chained('/api/base') PathPart('user/login') Args(0) ActionClass('REST') {
}

sub login_GET  {
  my ( $self, $c ) = @_;
  return $self->status_ok({
    entity => {
      user => $c->user->obj->userid
    }
  }) if $c->user_exists;
  
  $c->stash( template => 'user/login.tt' );
}

=head1 AUTHOR

Devin Austin

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
