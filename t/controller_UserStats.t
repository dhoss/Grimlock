use strict;
use warnings;
use Test::More;
use HTTP::Request::Common qw(DELETE);
use Test::WWW::Mechanize::PSGI;
use FindBin qw( $Bin );
use lib "$Bin/../t/lib";
use Data::Dumper;
use Test::DBIx::Class qw(:resultsets);
BEGIN { 
  $ENV{DBIC_TRACE} = 1;
  $ENV{CATALYST_CONFIG} = "t/grimlock_web_test.conf"
}

use Grimlock::Web;
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
    email   => 'herp@derp.com'
  }
);
ok $res->is_success;


done_testing;
