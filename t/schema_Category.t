use Test::More;
use strict;
use warnings;

use Test::DBIx::Class qw(:resultsets);
fixtures_ok 'user'
  => 'installed user fixtures';

fixtures_ok 'categories'
  => 'installed the basic fixtures from configuration files';

ok my $entry = Entry->create({
  title     => 'tits mcgee',
  body      => 'huehuheuehuehue',
  author    => User->find(1),
  published => 1,
  categories => {
    name => 'test'
  }
}), "created stub entry";
ok $entry->categories->name eq 'test', "category exists";
done_testing;
