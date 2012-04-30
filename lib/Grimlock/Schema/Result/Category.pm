package Grimlock::Schema::Result::Category;

use Grimlock::Schema::Candy -components => [
  qw(
      TimeStamp
      Helper::Row::ToJSON
      +DBICx::MaterializedPath
      )
];

use HTML::Scrubber;

#resultset_class 'Grimlock::Schema::ResultSet::Category';

primary_column categoryid => {
  data_type => 'int',
  is_nullable => 0,
  is_auto_increment => 1,
  extra => { unsigned => 1 },
};

unique_column name => {
  data_type => 'varchar',
  size => 200,
  is_nullable => 0,
};

unique_column display_name => {
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
  data_type => 'bigint',
  is_nullable => 1,
  extra => { unsigned => 1 },
  is_foreign_key => 1
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

belongs_to 'parent' => __PACKAGE__, {
  'foreign.categoryid' => 'self.parent',
},
{
  join_type => 'LEFT',
};

has_many 'children' => __PACKAGE__, {
  'foreign.parent' => 'self.categoryid'
};

has_many 'category_entries' => 'Grimlock::Schema::Result::Entry', {
  'foreign.category' => 'self.categoryid'
};

__PACKAGE__->mk_classdata( path_column => "path" );
__PACKAGE__->mk_classdata( path_separator => "." );

sub insert {
  my ( $self, @args ) = @_;

  # move me to a filter class
  my $guard = $self->result_source->schema->txn_scope_guard;

  $self->clean_params([qw( name )]);

  my $name = $self->name;

  #replace all non-words or spaces or underscores with '-'
  $name =~ s{(\W+|\s+|\_)}{-}g;
  # drop off the last character (and the newline char) if the
  # last character is a non-word
  chomp $name if $name =~ m/\W$/;

  # remove the last characters that are non-words from the title
  # (since we replace everything with '-', often times we get a title
  # that looks like "hi!!!!" -> "hi----", so we want to remove these
  # unsightly dashes
  $name =~ s#(\W+)$##;
  $self->display_name(lc $name);
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
  # need to add a filter to deal with this
  my $scrubber = $self->scrubber;
  for my $column ( @{ $params } ) {
    my $scrubbed = $scrubber->scrub($self->$column);
    $self->$column($scrubbed);
  }
  return $self
}


sub sqlt_deploy_hook {
  my ($self, $sqlt_table) = @_;

  $sqlt_table->add_index(name => 'tree_data', fields => ['parent']);
  $sqlt_table->add_index(name => 'category_index', fields => ['categoryid', 'name']);
}

sub TO_JSON {
  my $self = shift;
  return {
    children => $self->children_TO_JSON,
    parent   => $self->parent,
    %{ $self->next::method },
  }
}

sub children_TO_JSON {
  my $self = shift;
  my $children_rs = $self->children;
  my @child_collection;
  push @child_collection, {
    categoryid => $_->categoryid,
    name   => $_->name,
    path    => $_->path,
    parent  => $_->parent,
    created_at => $_->created_at . "",
    updated_at => $_->updated_at . "",
    children => $_->children_TO_JSON,
    parent   => $_->parent,
  } for $children_rs->all;

  return \@child_collection;
}

1;
