package Grimlock::App::Container::Test;

use strict;
use warnings;
use Fennec::Declare;
use Grimlock::App::Container;
use Test::More;
use Test::Exception;

tests compile {
  lives_ok { Grimlock::App::Container->new }, 'Creates a container ok';
  isa_ok(Grimlock::App::Container->new->schema, 'Grimlock::App::Schema', "Schema service exists");
}

done_testing;
1;  
