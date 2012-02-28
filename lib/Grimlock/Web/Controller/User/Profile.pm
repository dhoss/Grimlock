package Grimlock::Web::Controller::User::Profile;

use Moose;
use namespace::autoclean;
use Try::Tiny;

BEGIN { extends 'Grimlock::Web::Controller::API' };

sub index : Chained('../load_user') PathPart('profile') Args(0) ActionClass('REST') {
  my ( $self, $c ) = @_;
  $c->stash(
    template => 'user/profile/browse.tt'
  );
}

sub index_GET {
  my ( $self, $c ) = @_;
  my $user = $c->stash->{'user'};
  return $self->status_bad_request($c,
    message => "No such user"
  ) unless $user;

  return $self->status_ok($c,
    entity => {
      user => $user
    }
  );
}

__PACKAGE__->meta->make_immutable;
1;
