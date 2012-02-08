package Grimlock::Schema::Result::Draft;

use Grimlock::Schema::Candy -components => [
  qw(
      TimeStamp
      Helper::Row::ToJSON
      )
];

use HTML::Scrubber;


primary_column draftid => {
  data_type => 'int',
  is_nullable => 0,
  is_auto_increment => 1,
  extra => { unsigned => 1 },
};

unique_column title => {
  data_type => 'varchar',
  size => 200,
  is_nullable => 0,
};


column body => {
  data_type => 'text',
  is_nullable => 0,
};

column author => {
  data_type => 'int',
  is_nullable => 0,
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


belongs_to 'author' => 'Grimlock::Schema::Result::User', {
  'foreign.userid' => 'self.author',
};


sub insert {
  my ( $self, @args ) = @_;

  # move me to a filter class
  my $guard = $self->result_source->schema->txn_scope_guard;
  
  $self->clean_params([qw( title body )]);

  $self->next::method(@args);
  
  $guard->commit;
  return $self;
}


sub scrubber { 
  my $self = shift;
  return HTML::Scrubber->new(allow => [ qw[ p b i u hr br ] ] ); 
}

sub clean_params {
  my ( $self, $params ) = @_;
  my $scrubber = $self->scrubber;
  for my $column ( @{ $params } ) {
    warn "CLEANING $column";
    my $scrubbed = $scrubber->scrub($self->$column);
    $self->$column($scrubbed);
  }
  return $self
}


sub sqlt_deploy_hook {
  my ($self, $sqlt_table) = @_;
 
  $sqlt_table->add_index(name => 'user_drafts', fields => ['draftid', 'author']);
}

sub created_at {
  my $self = shift;
  my $created_at = $self->_created_at;
  my $date_time = $created_at->month_name . " "  . 
                  $created_at->day        . ", " . 
                  $created_at->year       . " at " .   
                  $created_at->hms        . " "  .
                  $created_at->time_zone->name;
  return $date_time;
}


sub TO_JSON {
  my $self = shift;
  return {
    body     => $self->body,
    %{ $self->next::method },
  }
}


1;
