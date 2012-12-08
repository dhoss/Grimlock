package Grimlock::App::Schema::Result::User::Test;
use strict;
use warnings;
use Fennec::Declare; # test_sort => 'ordered';
use Data::Dump qw( ddx dump );
use Test::DBIx::Class qw(:resultsets);

describe user {
  before_all setup  {
    fixtures_ok 'basic' => "Basic user fixtures installed ok";
  }

  tests user  {
    ok my $user = User->find({ name => 'herschel' }), "Found user ok";
    is_fields 'name', $user, ['herschel' ], 'name is correct';

    is_fields 'name', $user->roles, ['user'], 'correct roles';
  
    ok my $user = User->find({ name => 'herschel' }), "Found user ok";
    my $current_password = $user->password;
    diag $current_password;
    ok $user->reset_password, "Password resets ok";
    ok $current_password ne $user->password;
    diag $user->password;
  }
  
  after_all teardown  {
    ok(
      User->delete_all
      => "Data deleted"
    );
    ok (
      Role->delete_all
      => 'Roles deleted'
    );
  }


}
1;
