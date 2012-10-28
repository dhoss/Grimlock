package Grimlock::App::Schema::Result::User::Test;
use strict;
use warnings;
use Fennec::Declare;
use Data::Dump qw( ddx dump );
use Test::DBIx::Class {
  schema_class => 'Grimlock::App::Schema',
  connect_info => [ 'dbi:Pg:dbname=grimlock_test;host=localhost', 'grimlock_test', 'grimlock king' ],
  connect_opts  => { name_sep => '.', quote_char => '"' },
  force_drop_table => 1
}, 'User';

tests create {
  ok my $user = User->create({
    name     => 'herschel',
    password => 'suck it'
  }) => 'Created user ok';
}

tests read {
}

tests updated {
}

tests delete {
}

1;
