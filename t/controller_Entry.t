use strict;
use warnings;
use Test::More;
use HTTP::Request::Common qw(DELETE);
use Grimlock::Web;
use Test::WWW::Mechanize::PSGI;
use FindBin qw( $Bin );
use lib "$Bin/../t/lib";
use Data::Dumper;
use Test::DBIx::Class qw(:resultsets);

# this doesn't do shit for some reason
BEGIN { 
  $ENV{'GRIMLOCK_WEB_CONFIG_LOCAL_SUFFIX'} = "test";
  $ENV{'DBIC_TRACE'} = 1;
};

# create role records
fixtures_ok 'user'
  => 'installed the basic fixtures from configuration files';

my $mech = Test::WWW::Mechanize::PSGI->new( 
  app =>  Grimlock::Web->psgi_app(@_),
  cookie_jar => {}
);

# try to create entry without auth
$mech->post('/entry', 
  Content_Type => 'application/x-www-form-urlencoded',
  Content => {
    title => 'test',
    body => 'derp'
  }
);

ok !$mech->success, "doesn't work for unauthed users";

# create a post authed now
$mech->post('/user/login',
  Content_Type => 'application/x-www-form-urlencoded',
  Content => {
    name => 'herp',
    password => 'derp'
  }
);

BAIL_OUT "can't log in" unless $mech->success;

ok $mech->success, "logged in ok";

$mech->post('/entry',
 Content_Type => 'application/x-www-form-urlencoded',
  Content => {
    title => 'test title with spaces! <script>alert("and javascript!")</script>',
    body => 'derp'
  }
);

ok $mech->success, "POST worked";
$mech->get_ok('test-title-with-spaces-');
ok $mech->content_lacks('<script>alert("and javascript!")</script>'), "no scripts here";
ok $mech->content_contains("derp"), "content is correct";

$mech->post('/test-title-with-spaces-/reply',
 Content_Type => 'application/x-www-form-urlencoded',
  Content => {
    title => 'reply test',
    body => 'derpen'
  }
);

ok $mech->success, "reply post works ok";


done_testing();
