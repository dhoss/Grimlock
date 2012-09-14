use strict;
use warnings;

use Grimlock::App::Web;

my $app = Grimlock::App::Web->apply_default_middlewares(Grimlock::App::Web->psgi_app);
$app;

