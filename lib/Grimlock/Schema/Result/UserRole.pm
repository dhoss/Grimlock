package Grimlock::Schema::Result::UserRole;

use Grimlock::Schema::Candy -components => [
  qw(
      InflateColumn::DateTime
      TimeStamp
      Helper::Row::ToJSON
      )
];

column userid => {
  data_type => 'int',
  is_nullable => 0,
};

column  roleid => {
  data_type => 'int',
  is_nullable => 0,
};

belongs_to 'user' => 'Grimlock::Schema::Result::User', {
  'foreign.userid' => 'self.userid',
},
{
  on_delete => 'cascade',
  on_update => 'cascade',
};

belongs_to 'role' => 'Grimlock::Schema::Result::Role', {
  'foreign.roleid' => 'self.roleid',
},
{
  on_delete => 'restrict',
};

primary_key ("userid", "roleid");

1;

