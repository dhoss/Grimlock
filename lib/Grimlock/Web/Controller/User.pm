package Grimlock::Web::Controller::User;
use Moose;
use namespace::autoclean;
use Try::Tiny;
use Data::Dumper;

BEGIN { extends 'Grimlock::Web::Controller::API' };

=head1 NAME

Grimlock::Web::Controller::User - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut



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

sub create : Chained('/api/base') PathPart('user') Args(0) ActionClass('REST') {}

sub create_POST {
  my ( $self, $c ) = @_;
  my $params ||= $c->req->data || $c->req->params;
  $c->log->debug("POST PARAMS " . Dumper $params );
  my $user;
  try {
    $user = $c->model('Database::User')->create({
      name     => $params->{'name'},
      password => $params->{'password'},
    })->add_to_roles({
      name => 'user'
    }) || die "Can't create user: $!";
    
  } catch {
    $self->status_bad_request($c,
      message => $_
    );
  };
  $self->status_created($c,
    location => $c->uri_for_action('/user/read', [ 
      $user->userid
    ]),
    entity => {
      user => $user
    }
  );

}

=head1 AUTHOR

Devin Austin

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
