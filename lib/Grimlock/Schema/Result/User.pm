package Grimlock::Schema::Result::User;

use Grimlock::Schema::Candy -components => [
  qw(
      InflateColumn::DateTime
      TimeStamp
      Helper::Row::ToJSON
      )
];

primary_column userid => {
  data_type => 'bigserial',
  is_auto_increment => 1,
  is_nullable => 0,
};

unique_column name => {
  data_type => 'varchar',
  size => 200,
  is_nullable => 0,
};

column password => {
  data_type => 'char',
  size => 59,
  is_nullable => 0,
  encode_column => 1,
  encode_class  => 'Crypt::Eksblowfish::Bcrypt',
  encode_args   => { key_nul => 0, cost => 8 },
  encode_check_method => 'check_password',
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
  set_on_update => 1,
};

has_many 'entries' => 'Grimlock::Schema::Result::Entry', {
  'foreign.author' => 'self.userid',
};

has_many 'user_roles' => 'Grimlock::Schema::Result::UserRole', {
  'foreign.user' => 'self.userid'
};

many_to_many 'roles' => 'user_roles', 'role';


1;
