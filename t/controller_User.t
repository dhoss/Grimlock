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
$mech->get_ok('/user/2');
$mech->get_ok('/users' );
ok $mech->put( '/user/2',
  Content_Type => 'application/x-www-form-urlencoded',
  Content => 'name=fartnuts'  
)->is_success;

$mech->get_ok('/user/2');
$mech->content_contains("fartnuts");
done_testing();
