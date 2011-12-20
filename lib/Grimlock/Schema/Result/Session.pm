package Grimlock::Schema::Result::Session;

use Grimlock::Schema::Candy -components => [
  qw(
      InflateColumn::DateTime
      TimeStamp
      Helper::Row::ToJSON
      )
];

primary_column sessoinid => {
  data_type => 'char',
  is_nullable => 0,
  size => 72
};

column session_data => {
  data_type => 'text',
};

column expires => {
  data_type => 'int',
};

1;

