package Grimlock::Schema::Result::Tag;

use Grimlock::Schema::Candy -components => [
  qw(
      TimeStamp
      Helper::Row::ToJSON
      )
];



primary_column tagid => {
  data_type => 'int',
  is_nullable => 0,
  is_auto_increment => 1,
  extra => { unsigned => 1 },
};

unique_column name => {
  data_type => 'varchar',
  is_nullable => 0,
  size => 255
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

has_many 'tag_entries' => 'Grimlock::Schema::Result::EntryTag', {
  'foreign.tag' => 'self.tagid'
};

1;
