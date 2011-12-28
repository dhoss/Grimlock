use Test::More;
use strict;
use warnings;

use Test::DBIx::Class qw(:resultsets);

fixtures_ok 'basic'
  => 'installed the basic fixtures from configuration files';

my $user;
my $entry;
ok $user = User->create({ name => 'herp', password => 'derp' }), "found our user " . $user->name;
ok $entry = $user->create_related('entries', {
    title => "title with spaces and metacharacters___!",
    body => "huehuheuhuehue"
  }), "Created entry " . $entry->title;
ok ( ( $entry->display_title !~ m/(\s+|\_)/g ) && ( $entry->display_title =~ m/[a-zA-Z0-9\-]/g )), "title created properly";
done_testing;
