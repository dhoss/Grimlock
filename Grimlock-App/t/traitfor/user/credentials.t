package Grimlock::TraitFor::User::Credentials::Test;
use strict;
use warnings;
use Fennec::Declare; # test_sort => 'ordered';
use Data::Dump qw( ddx dump );

describe credential {
  my $user;
  before_all setup {
    ok $user = User->new, "created new user object";
  }
 
  tests generate_new_password {
    ok $user->generate_password(), "Generates a password ok";
    diag $user->generate_password();
  }

  tests reset_password {
    my $old_pass = $user->password;
    diag $old_pass;
    ok $user->reset_password, "Reset new password ok";
    ok $old_pass ne $user->password, "new pass is different from the old password";
    diag $user->reset_password;
  }
}

{
  package User;
  use Moose;
  use namespace::autoclean;

  has 'user' => (
    is       => 'ro',
    lazy     => 1,
    required => 1,
    default  => sub { shift; }
  );

  with 'Grimlock::TraitFor::User::Credentials';
  has 'password' => (
    is       => 'rw',
    lazy     => 1,
    required => 1,
    default  => "changeme",
  );

  sub update {
    my $self = shift;
    return { password => $self->password };
  }
  __PACKAGE__->meta->make_immutable;
}
1;
