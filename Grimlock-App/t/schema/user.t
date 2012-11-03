package Grimlock::App::Schema::Result::User::Test;
use strict;
use warnings;
use Fennec::Declare test_sort => 'ordered';
use Data::Dump qw( ddx dump );
use Test::DBIx::Class qw(:resultsets);

describe user {
  before_all setup  {
    fixtures_ok 'basic' => "Basic user fixtures installed ok";
  }

  tests read  {
    ok my $user = User->find({ name => 'herschel' }), "Found user ok";
    is_fields $user, {
      name => 'herschel'
    }, 'name is correct';

    is_fields ['name'], $user->roles, [
      { name => 'user' }
    ], 'correct roles';
  
  }

describe skip_group ( skip => 'skip these tests' ) {
  describe updated => (
    todo => 'coming soon',
    code => sub { return }
  );

  describe delete => (
    todo => 'coming soon',
    code => sub { return }
  );
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
