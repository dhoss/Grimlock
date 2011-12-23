use strict;
use warnings;
use Test::More;
use HTTP::Request::Common;

use Catalyst::Test 'Grimlock::Web';
use Grimlock::Web::Controller::User;

ok( request( GET '/users' )->is_success, 'Request should succeed' );
done_testing();
