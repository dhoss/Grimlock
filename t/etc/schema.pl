{
  'schema_class' => 'Grimlock::Schema',
  'connect_info' => ['dbi:SQLite:dbname=grimlock_test.db', '', ''],
  'force_drop_table' => 1,
  'resultsets' => [
    'User',
    'Entry',
    'Role',
    'UserRole',
    'Category'
  ],
  'fixture_sets' => {
    'basic' => [
    ],
    'user' => [
      'User' => [
        ['name', 'password', 'email'],
        ['herp', 'derp', 'herp@derp.com'],
      ],
    ],
    'categories' => [
      'Category' => [
       ['name'],
       ['test'],
       ['test 2'],
       ['test 3'],
       ['test 4']
      ]
    ]
  }
};

