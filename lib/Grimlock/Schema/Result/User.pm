package Grimlock::Schema::Result::User;

use Grimlock::Schema::Candy -components => [
  qw(
      InflateColumn::DateTime
      TimeStamp
      Helper::Row::ToJSON
      EncodedColumn
      )
];

resultset_class 'Grimlock::Schema::ResultSet::User';

primary_column userid => {
  data_type => 'bigserial',
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

has_many 'entries' => 'Grimlock::Schema::Result::Entry', {
  'foreign.author' => 'self.userid',
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


1;
