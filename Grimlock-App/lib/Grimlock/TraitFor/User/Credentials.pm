package Grimlock::TraitFor::User::Credentials;

# ABSTRACT: Methods for dealing with user credentials

use Moose::Role;
use namespace::autoclean;
use Text::Password::Pronouncable::RandomCase;

requires 'user';

sub reset_password {
  my $self = shift;
  my $user = $self->user;
  $user->password( $self->generate_password() ) ;
  $user->update;
  return $user;
}

sub generate_password {
  my $self = shift;
  return Text::Password::Pronouncable::RandomCase->generate(6, 10);
}

1;