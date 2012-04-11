package Grimlock::Schema::ResultSet::Entry;
use strict;
use warnings;
use base 'DBIx::Class::ResultSet';

sub front_page_entries {
  my ($self, $params) = @_;
  return $self->search(
    {
      parent    => undef,
      published => 1
    },
    {
      rows => $params->{'limit'} || 5,
      order_by => {
        -desc => $params->{'order_by'} || 'created_at'
      },
      page => $params->{'page'} || 1
    }
  );
}

sub published {
  my ( $self, $params ) = @_;
  return $self->search(
    {
      published => 1
    },
    {
      rows => $params->{'limit'} || 50,
      order_by => {
        -desc => $params->{'order_by'} || 'created_at'
      },
      page => $params->{'page'} || 1
    }
  );
}

1;

