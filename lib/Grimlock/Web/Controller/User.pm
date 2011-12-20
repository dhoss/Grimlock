package Grimlock::Web::Controller::User;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller::REST'; }

## move me to a base controller

__PACKAGE__->config(
  map => {
    'text/html' => [ 'View', 'HTML' ],
    'application/json' => [ 'View', 'JSON' ],
  }
);

=head1 NAME

Grimlock::Web::Controller::User - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;
    $c->res->redirect(
      $c->uri_for_action('/user/login')
    ) unless $c->user_exists;

}


sub login : Local ActionClass('REST') {
  my ( $self, $c ) = @_;
}

sub login_GET {
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
