use strict;
use warnings;
use Test::More;
use HTTP::Request::Common;

use Test::WWW::Mechanize::PSGI;
use Grimlock::Web::Controller::User;

my $mech = Test::WWW::Mechanize::PSGI->new( app => Grimlock::Web->psgi_app );


$mech->post_ok('/user', {
  name => 'herp',
  password => 'derp',
});

$mech->get_ok('/users' );
done_testing();
