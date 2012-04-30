package Grimlock::Schema::Result::EntryTag;

use Grimlock::Schema::Candy -components => [
  qw(
      TimeStamp
      Helper::Row::ToJSON
      )
];



primary_column tag => {
  data_type => 'int',
  is_nullable => 0,
  is_auto_increment => 1,
  extra => { unsigned => 1 },
};

primary_column entry => {
  data_type => 'int',
  is_nullable => 0,
  is_auto_increment => 1,
  extra => { unsigned => 1 },
};

column created_at => {
  data_type => 'datetime',
  is_nullable => 0,
  set_on_create => 1,
  accessor => '_created_at'
};

column updated_at => {
  data_type => 'datetime',
  is_nullable => 1,
  set_on_create => 1,
  set_on_update => 1
};

belongs_to 'entry' => 'Grimlock::Schema::Result::Entry', {
  'foreign.entryid' => 'self.entry',
};

belongs_to 'tag' => 'Grimlock::Schema::Result::Tag', {
  'foreign.tag' => 'self.tag',
};

1;
