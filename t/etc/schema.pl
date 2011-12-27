{
  'schema_class' => 'Grimlock::Schema',
  'connect_info' => ['dbi:Pg:dbname=grimlock_test;port=5433', 'grimlock', 'lairdo'],
  'force_drop_table' => 1,
  'resultsets' => [
    'User',
    'Entry',
    'Role',
    'UserRole',
  ],
  'fixture_sets' => {
    'basic' => [
    ],
    'user' => [
      'User' => [
        ['name', 'password'],
        ['herp', 'derp'],
      ],
    ],
  }
};

