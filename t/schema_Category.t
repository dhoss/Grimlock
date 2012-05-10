use Test::More;
use strict;
use warnings;

use Test::DBIx::Class qw(:resultsets);
fixtures_ok 'user'
  => 'installed user fixtures';

fixtures_ok 'categories'
  => 'installed the basic fixtures from configuration files';

Entry->create({
  title     => $_,
  body      => 'huehuheuehuehue',
  author    => User->find(1),
  published => 1,
  categories => {
    name => 'test'
  }
}) for qw{ first second third };

my $entry = Entry->first;
ok $entry->categories->name eq 'test', "category exists";
my @entries_in_category;
push @entries_in_category, $_->title for Category->find({ name => 'test' })->entries->all;
ok scalar @entries_in_category == 3, "three entries in the 'test' category";
done_testing;
