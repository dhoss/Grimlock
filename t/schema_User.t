use strict;
use warnings;
use Data::Dumper;
use Test::More;
use Test::Exception;
use Test::DBIx::Class qw(:resultsets);

fixtures_ok 'basic'
  => 'installed the basic fixtures from configuration files';

my $user;
ok $user = User->create({ name => 'herp', password => 'derp' }), "found our user " . $user->name;
ok $user->password('ass');
ok $user->update, "updated pass";
ok ! $user->check_password('derp'), "old pass doesn't work";
ok $user->check_password('ass'), "password checks out";
ok $user->has_role('user'), $user->name . " has role user";
ok !$user->has_role('admin'), $user->name . " does NOT have the admin role";


### stats stuff
diag "Creating entries for stats tests";
for ( 1 .. 10 ) {
  ok $user->add_to_entries({
    title => "test $_",
    body => "hhuhuhuhuh"
  }), "created $_";
}

ok my $entry_old = $user->entries->first->update({ created_at => DateTime->now->subtract( days => 24 ) }), 
"updated random entry to have a create date of 24 days ago";


my $date_range = $user->date_range_for_stats;
ok $date_range == 24, "date range should be 24 days";
my $run = $user->build_graph_run(24);
my @expected_array;
my $today = DateTime->now;
push @expected_array, $today->subtract( days => 1 ) for 1..24;
dies_ok { $user->build_graph_run; }, "should die if called with no params";
is_deeply $user->build_graph_run(24), \@expected_array;
done_testing;
