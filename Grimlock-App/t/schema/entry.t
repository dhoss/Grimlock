package Grimlock::App::Schema::Result::Entry::Test;
use strict;
use warnings;
use Fennec::Declare test_sort => 'ordered';
use Data::Dump qw( ddx dump );
use Test::DBIx::Class qw(:resultsets);

describe entry {
  before_all setup  {
    fixtures_ok 'basic' => "Basic user fixtures installed ok";
    fixtures_ok 'entry' => "Entry fixtures installed ok";
  }

  tests read  {
    ok my $user = User->find({ name => 'herschel' }), "Found user ok";
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
