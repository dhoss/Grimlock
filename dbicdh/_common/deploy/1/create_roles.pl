sub {
   my $schema = shift;
   $schema->resultset('Role')->populate([
      ['name'],
      ['admin'],
      ['user']
   ]);
};

