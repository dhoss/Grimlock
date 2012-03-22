package Grimlock::Schema::Result::User;

use Grimlock::Schema::Candy -components => [
  qw(
      InflateColumn::DateTime
      TimeStamp
      Helper::Row::ToJSON
      EncodedColumn
      )
];
use Data::Dump;
use Text::Password::Pronounceable;
use List::AllUtils qw( :all );

resultset_class 'Grimlock::Schema::ResultSet::User';

primary_column userid => {
  data_type => 'int',
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
  size => 60,
  is_nullable => 0,
  encode_column => 1,
  encode_class  => 'Crypt::Eksblowfish::Bcrypt',
  encode_args   => { key_nul => 1, cost => 8 },
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

unique_column email => {
  data_type => 'varchar',
  size      => 255,
  is_nullable => 1,
};

has_many 'entries' => 'Grimlock::Schema::Result::Entry', {
  'foreign.author' => 'self.userid',
};

has_many 'drafts' => 'Grimlock::Schema::Result::Entry', 
  # 'foreign.userid'   => 'self.userid',
  #'foreign.published' => 0
  sub {
    my $args = shift;
    return {
      "$args->{foreign_alias}.author"   =>  "$args->{self_alias}.userid",
      "$args->{foreign_alias}.published" => 0
    };
};

has_many 'user_roles' => 'Grimlock::Schema::Result::UserRole', {
  'foreign.userid' => 'self.userid'
};

many_to_many 'roles' => 'user_roles', 'role';

sub insert {
  my ( $self, @args ) = @_;
  
  my $guard = $self->result_source->schema->txn_scope_guard;
  $self->next::method(@args);
  $self->add_to_roles({ name => "user" });
  $guard->commit;

  return $self;
}

sub has_role {
  my ( $self, $role ) = @_;
  return $self->user_roles->search_related('role',
    {
      name => $role
    }
  )->count;
}

sub entry_count {
  my $self = shift;
  return $self->entries->count;
}

sub reply_count {
  my $self = shift;
  return $self->entries->search({ parent => { '!=', undef }})->count;
}

sub generate_random_pass {
  my $self = shift;
  Text::Password::Pronounceable->generate(6,10);
}

sub create_entry {
  my ( $self, $params ) = @_;
  return $self->entries->update_or_create($params,
    {
      key => 'entries_title'
    }
  );
}

sub create_draft { 
  my ( $self, $params ) = @_;
  return $self->entries->update_or_create({
    published => 0,
    %{ $params } 
  });
}

sub TO_JSON {
  my $self = shift;
  return {
    created_at => $self->created_at . "",
    updated_at => $self->updated_at . "",
    entries => $self->entries_TO_JSON,
    %{ $self->next::method },
  };
}

sub entries_TO_JSON {
  my $self = shift;
  my $entry_rs = $self->entries;
  my @entry_collection;
  push @entry_collection, {
    entryid => $_->entryid,
    title   => $_->title,
  } for $entry_rs->all;
  
  return \@entry_collection;
}

sub draft_count {
  my $self = shift;
  return $self->drafts->count;
}

# this is here so we can ask for dates per user
sub get_all_entry_dates {
  my $self = shift;
  warn "ENTRY DATES";
  my @dates =  map { $_->created_at->epoch } $self->entries->all;
  return \@dates;
}

# see above
# returns a date range in days
sub date_range_for_stats {
  my $self = shift;
  my $month = shift || DateTime->now->month;
  my $today = DateTime->now;
  warn "GOT TO DATE RANGE";
  my $from_db = $self->date_from_db;
  my $min =  $self->entries->search(
     
    [
            created_at => { 
              '<=', $from_db->format_datetime(DateTime->last_day_of_month( month => $today->month, year => $today->year ))
            },
            created_at => { 
              '>=', $from_db->format_datetime(DateTime->new( month => $today->month, year => $today->year, day => 1 ))
            }
          ]
    )->get_column('created_at')->func('min');
#    {
#      select => { MIN => 'created_at' },
#      as => [qw( min_created_at )]
#    
#    }
  warn "MIN $min";
  my $first_post = $from_db->parse_datetime($min);
  return $today->delta_days($first_post)->in_units('days');
}

sub build_graph_range {
  my $self = shift;
  my @dates;
  my $today = DateTime->now;
  warn "BUILD";
  my $range = $self->date_range_for_stats;
  warn "RANGE $range";
  # seems dumb
  push @dates, $today->day;
  push @dates, $today->subtract( days => 1 )->day for 1..$range;
  return [ reverse @dates ]
}

sub build_graph_domain {
  my $self = shift;
  my $year = shift || DateTime->now->year;
  my $month = shift || DateTime->now->month;
  my $range = $self->build_graph_range;
  my @domain;
  my @dates;
  my $from_db = $self->date_from_db;
  for my $day ( @{ $range } ) {
    my $dt =  $from_db->format_datetime(
      DateTime->new( day => $day, year => $year, month => $month )
    );
    push @dates, $dt; 
  }
  push @domain, $self->number_of_posts_for_date($_) for @dates;
  dd @domain;
  if ( scalar @domain< 1 ) {
    my @no_post_range = map { 0 } @{ $range };
    warn "RANGE WITH NO POSTS " .  dd \@no_post_range;
    return \@no_post_range;
  }
  return \@domain;
}

sub number_of_posts_for_date {
  my ( $self, $date ) = @_;
  my $from_db = $self->date_from_db;
  my $formatted_date = $from_db->parse_datetime($date)->ymd('-') ;
  my $count_rs = $self->entries->search({
    created_at => { -like => $formatted_date . "%" },
    published => 1,
    parent    => undef,
  });
  return $count_rs->count;
}

sub max_daily_posts {
  my $self = shift;
  my @posts_per_day = @{ $self->build_graph_domain };
  warn "POSTS PER DAY " . dd \@posts_per_day;
  my @counts;
  push @counts, $_[1] for @posts_per_day;
  return max @counts;
}

sub date_from_db {
  my $self = shift;
  return DateTime::Format::DBI->new($self->result_source->schema->storage->dbh);
}

1;
