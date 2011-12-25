package Grimlock::Schema::ResultSet::User;
use strict;
use warnings;
use base 'DBIx::Class::ResultSet';

sub has_role {
  my ( $self, $role ) = @_;
  return $self->user_roles->search_related('roles',
    {
      name => $role
    }
  )->count;
}

1;
