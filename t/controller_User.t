use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Grimlock::Web';
use Grimlock::Web::Controller::User;

ok( request('/user')->is_success, 'Request should succeed' );
done_testing();
