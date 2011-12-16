package Grimlock::Schema::Result::Entry;

use SuiteSetup::Schema::Candy -components => [
  qw(
      InflateColumn::DateTime
      TimeStamp
      Helper::Row::ToJSON
      )
];

primary_column entryid => {
  data_type => 'bigserial',
  is_nullable => 0,
  is_auto_increment => 1,
  extra => { unsigned => 1 },
};

column title => {
  data_type => 'varchar',
  size => 200,
  is_nullable => 0,
};

column body => {
  data_type => 'text',
  is_nullable => 0,
};

column author => {
  data_type => 'int',
  is_nullable => 0,
  extra => { unsigned => 1 },
};

column created_at => {
  data_type => 'datetime',
  is_nullable => 0,
  set_on_create => 1,
};

column updated_at => {
  data_type => 'datetime',
  is_nullable => 1,
  set_on_create => 1,
  set_on_update => 1
};

belongs_to 'user' => 'Grimlock::Schema::Result::User', {
  'foreign.userid' => 'self.author',
},
{
  on_delete => "cascade"
};

1;
