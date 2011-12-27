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


BEGIN { $ENV{'CATALYST_WEB_CONFIG_LOCAL_SUFFIX'} = 'test' };

# create role records
fixtures_ok 'user'
  => 'installed the basic fixtures from configuration files';

my $mech = Test::WWW::Mechanize::PSGI->new( 
  app =>  Grimlock::Web->psgi_app(@_),
  cookie_jar => {}
);

done_testing();
