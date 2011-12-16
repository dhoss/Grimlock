package Grimlock::Schema::Result::Role;

use SuiteSetup::Schema::Candy -components => [
  qw(
      InflateColumn::DateTime
      TimeStamp
      Helper::Row::ToJSON
      )
];

primary_column roleid => {
  data_type => 'bigserial',
  is_auto_increment => 1,
  is_nullable => 0,
};

column name => {
  data_type => 'varchar',
  size => '50',
  is_nullable => 0,
};

has_many 'user_roles' => 'Grimlock::Schema::Result::UserRole', {
  'foreign.role' => 'self.roleid',
},
{
  on_delete => "cascade",
};

1;
