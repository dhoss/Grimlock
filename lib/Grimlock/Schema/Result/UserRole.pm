package Grimlock::Schema::Result::UserRole;

use Grimlock::Schema::Candy -components => [
  qw(
      InflateColumn::DateTime
      TimeStamp
      Helper::Row::ToJSON
      )
];

column user => {
  data_type => 'int',
  is_nullable => 0,
};

column  role => {
  data_type => 'int',
  is_nullable => 0,
};

belongs_to 'user' => 'Grimlock::Schema::Result::User', {
  'foreign.userid' => 'self.user',
},
{
  on_delete => 'cascade',
  on_update => 'cascade',
};

belongs_to 'role' => 'Grimlock::Schema::Result::Role', {
  'foreign.roleid' => 'self.role',
},
{
  on_delete => 'restrict',
};

1;

