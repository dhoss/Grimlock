use strict;
use warnings;
use Test::More;
use HTTP::Request::Common;

use Test::WWW::Mechanize::PSGI;
use Grimlock::Web;
use Data::Dumper;
use Test::DBIx::Class qw(:resultsets);

BEGIN { $ENV{'GRIMLOCK_WEB_CONFIG_LOCAL_SUFFIX'} = 'test' };

fixtures_ok 'basic'
  => 'installed the basic fixtures from configuration files';

my $mech = Test::WWW::Mechanize::PSGI->new( app =>  Grimlock::Web->psgi_app(@_)  );


my $res = $mech->post('/user', 
  Content_Type => 'application/x-www-form-urlencoded',
  Content => {
    name => 'herpy',
    password => 'derp',
  }
);
ok $res->is_success;

$mech->get_ok('/users' );
done_testing();
