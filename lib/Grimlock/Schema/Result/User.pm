package Grimlock::Scheam::Result::User;

use SuiteSetup::Schema::Candy -components => [
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

column name => {
  data_type => 'varchar',
  size => 200,
  is_nullable => 0,
};

column password => {
  data_type => 'char',
  size => 59,
  encode_column => 1,
  encode_class  => 'Crypt::Eksblowfish::Bcrypt',
  encode_args   => { key_nul => 0, cost => 8 },
  encode_check_method => 'check_password',
};

1;
