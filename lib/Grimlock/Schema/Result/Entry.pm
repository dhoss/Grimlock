package Grimlock::Schema::Result::Entry;

use Grimlock::Schema::Candy -components => [
  qw(
      InflateColumn::DateTime
      TimeStamp
      Helper::Row::ToJSON
      +DBICx::MaterializedPath
      )
];

use HTML::Scrubber;

__PACKAGE__->path_column("path");
__PACKAGE__->path_separator(".");

resultset_class 'Grimlock::Schema::ResultSet::Entry';

primary_column entryid => {
  data_type => 'bigserial',
  is_nullable => 0,
  is_auto_increment => 1,
  extra => { unsigned => 1 },
};

unique_column title => {
  data_type => 'varchar',
  size => 200,
  is_nullable => 0,
};

unique_column display_title => {
  data_type => 'varchar',
  size => 200,
  is_nullable => 0,
};

column path => {
  data_type => 'varchar',
  size      => 255,
  is_nullable => 1
};

column parent => {
  data_type => 'bigserial',
  is_nullable => 1,
  extra => { unsigned => 1 },
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
};

column updated_at => {
  data_type => 'datetime',
  is_nullable => 1,
  set_on_create => 1,
  set_on_update => 1
};

belongs_to 'user' => 'Grimlock::Schema::Result::User', {
  'foreign.userid' => 'self.author',
},
{
  on_delete => "cascade",
  on_update => "cascade",
};

belongs_to 'parent' => __PACKAGE__, {
  'foreign.entryid' => 'self.parent'
},
{
  cascade_delete => 1,
  cascade_update => 1,
};

has_many 'children' => __PACKAGE__, {
  'foreign.parent' => 'self.entryid'
};

sub insert {
  my ( $self, @args ) = @_;

  # move me to a filter class
  my $guard = $self->result_source->schema->txn_scope_guard;
  
  $self->clean_params([qw( title body )]);

  # move me to a filter class
  my $title = $self->title;
  $title =~ s{(\W+|\s+|\_)}{-}g;
  chomp $title if $title =~ m/\W$/;
  $self->display_title($title);
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
 
  $sqlt_table->add_index(name => 'tree_data', fields => ['parent']);
}


1;
