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

sub base : Chained('/api/base') PathPart('') CaptureArgs(0) {}

sub load_user : Chained('base') PathPart('user') CaptureArgs(1) {
  my ( $self, $c, $userid ) = @_;
  my $user = $c->model('Database::User')->find($userid);
  $c->stash( user => $user );
}

sub list : Chained('base') PathPart('users') Args(0) ActionClass('REST'){
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

sub login  : Chained('base') PathPart('user/login') Args(0) ActionClass('REST') {
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

sub login_POST {
  my ( $self, $c ) = @_;
  my $params ||= $c->req->data || $c->req->params;
  if ( $c->authenticate({ 
        name => $params->{'name'},
        password => $params->{'password'}
      })
  ) {
        return $self->status_ok($c,
          entity => {
            message => "Logged in successfully"
          }
        );
  }
  
  return $self->status_bad_request($c,
    message => "incorrect username/password"
  );
}

sub create : Chained('base') PathPart('user') Args(0) ActionClass('REST') {}

sub create_POST {
  my ( $self, $c ) = @_;
  my $params ||= $c->req->data || $c->req->params;
  $c->log->debug("POST PARAMS " . Dumper $params );
  my $user;
  try {

    $user = $c->model('Database::User')->create({
      name     => $params->{'name'},
      password => $params->{'password'},
    }) || die "Can't create user: $!";
    
    $self->status_created($c,
      location => $c->uri_for_action('/user/browse', [ 
        $user->userid
      ]),
      entity => {
        user => $user
      }
    );
 
  } catch {

    $self->status_bad_request($c,
      message => $_
    );
 
  };
 
}

sub browse : Chained('load_user') PathPart('') Args(0) ActionClass('REST') {
  my ( $self, $c ) = @_;
  if ( !( my $user = $c->stash->{'user'} ) ) {
    return $self->status_bad_request($c,
      message => "Can't find user with that id"
    );
  }

}

sub browse_GET {
  my ( $self, $c ) = @_;
  my $user => $c->stash->{'user'};  
  return $self->status_ok($c, 
    entity => {
      user => $user
    }
  );
}


sub browse_PUT {
  my ( $self, $c ) = @_;
  my $user = $c->stash->{'user'};
  return $self->status_bad_request($c, 
    message => "You don't have permission to modify this user"
  ) unless $user->has_role('admin') || ( $user->userid == $c->user->obj->userid );
  try { 
    my $params ||= $c->req->data || $c->req->params;
    my @columns = $user->columns;
     
    for my $column ( @columns ) {
      for my $key ( keys %{ $params } ) {  
        if ( defined $params->{$column} ) {
          $user->$column($params->{$key});
        }
      }
    }
    $user->update || die $!;
    $self->status_ok($c, 
      entity => {
        user => $user 
      }
    );
  } catch {
    $self->status_bad_request($c, 
      message => $_
    );
  };
}

=head1 AUTHOR

Devin Austin

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
