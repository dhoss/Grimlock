use strict;
use warnings;

use Test::More;
use HTTP::Request::Common qw(DELETE PUT);
use Test::WWW::Mechanize::PSGI;
use FindBin qw( $Bin );
use lib "$Bin/../t/lib";
use Data::Dumper;
use Test::DBIx::Class qw(:resultsets);

BEGIN {
  $ENV{DBIC_TRACE} = 1;
  $ENV{CATALYST_CONFIG} = "t/grimlock_web_test.conf"
}
# must be AFTER this begin statement so that these env vars take root properly
use Grimlock::Web;

# create role records
fixtures_ok 'basic'
  => 'installed the basic fixtures from configuration files';

my $mech = Test::WWW::Mechanize::PSGI->new(
  app =>  Grimlock::Web->psgi_app(@_),
  cookie_jar => {}
);


$mech->get_ok('/category');
done_testing();
