{
  'schema_class' => 'Grimlock::App::Schema',
  'connect_info' => [ 'dbi:Pg:dbname=grimlock_test;host=localhost', 'grimlock_test', 'grimlock king' ],
  'connect_opts'  => { name_sep => '.', quote_char => '"' },
  'force_drop_table' => 1,
  'resultsets' => [
    'User', 'UserRole', 'Role',
    'Entry', 'EntryTag', 'Session'
  ],
  'fixture_sets' => {
    'basic' => [
      'Role' => [
        [ 'name' ],
        [ 'admin' ], 
        [ 'user' ]  
      ],
      'User' => [
        [ 'name', 'password' ],
        [ 'herschel', 'shit turd rats' ], 
      ],
     ],
    'entry' => [
      'Entry' => [
        ['title'], ['body'], ['owner'],
        ['test entry'], ['huehuehuehuehuehue'], [1],
      ],
    ],
  }
}
