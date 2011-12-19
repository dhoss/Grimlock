package Grimlock::Schema::Candy;
 
use base 'DBIx::Class::Candy';
 
sub base { $_[1] || 'Grimlock::Schema::Result' }
sub perl_version { 12 }
sub autotable { 1 }
1;

