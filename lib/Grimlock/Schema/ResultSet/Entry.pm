package Grimlock::Schema::ResultSet::Entry;
use strict;
use warnings;
use base 'DBIx::Class::ResultSet';

sub front_page_entries {
  my ($self, $limit) = @_;
  return $self->search(
    {
      published => 1
    }, 
    {
      rows => $limit || 50,
      order_by => { 
        -desc => 'created_at'
      },
    }
  );
}

1;

