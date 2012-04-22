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
}), "created stub entry";
ok $entry->add_to_entry_categories(
  { category => Category->find({name => 'test' }) },
) , "added category";
ok $entry->add_to_entry_categories(
  { category => Category->find({name => 'test 2' }) },
) , "added category";
my @categories;
push @categories, $_->category->name for $entry->entry_categories->all;
is_deeply \@categories, [ 'test', 'test 2' ], "all categories present";
done_testing;
