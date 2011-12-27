use strict;
use warnings;
use Test::More;
use HTTP::Request::Common;

use Test::WWW::Mechanize::PSGI;
use FindBin qw( $Bin );
use lib "$Bin/../t/lib";
use Grimlock::Web;
use Data::Dumper;
use Test::DBIx::Class qw(:resultsets);


BEGIN { $ENV{'CATALYST_WEB_CONFIG_LOCAL_SUFFIX'} = 'test' };

# create role records
fixtures_ok 'basic'
  => 'installed the basic fixtures from configuration files';

my $mech = Test::WWW::Mechanize::PSGI->new( 
  app =>  Grimlock::Web->psgi_app(@_),
  cookie_jar => {}
);

# create a user
my $res = $mech->post('/user', 
  Content_Type => 'application/x-www-form-urlencoded',
  Content => {
    name => 'herpy',
    password => 'derp',
  }
);
ok $res->is_success;

# retrieve created user
$mech->get_ok('/user/1');
diag $mech->content;

# retrieve user listing
$mech->get_ok('/users' );

# attempt to update a user without authing
ok !($mech->put( '/user/1',
  Content_Type => 'application/x-www-form-urlencoded',
  Content => 'name=fartnuts'  
)->is_success), "should fail since we aren't logged in";

# login
$mech->post('/user/login',
  Content_Type => 'application/x-www-form-urlencoded',
  Content => {
    name => 'herpy',
    password => 'derp'
  }
);

ok $mech->success, "login works";

# update a user (authenticated)
ok $mech->put( '/user/1',
  Content_Type => 'application/x-www-form-urlencoded',
  Content => 'name=fartnuts'  
)->is_success;

# get updated user, verify content is correct
$mech->get_ok('/user/1');
$mech->content_contains("fartnuts");

# delete user, unauthenticated
$mech->get_ok('/user/logout');
done_testing();
