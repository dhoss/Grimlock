use utf8;
package Grimlock::App::Schema::Result::User;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grimlock::App::Schema::Result::User

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=item * L<DBIx::Class::TimeStamp>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime", "TimeStamp");

=head1 TABLE: C<users>

=cut

__PACKAGE__->table("users");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'users_id_seq'

=head2 name

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 password

  data_type: 'char'
  is_nullable: 0
  size: 59

=head2 created_on

  data_type: 'timestamp with time zone'
  default_value: current_timestamp
  is_nullable: 0
  original: {default_value => \"now()"}

=head2 updated_on

  data_type: 'timestamp with time zone'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "users_id_seq",
  },
  "name",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "password",
  { data_type => "char", is_nullable => 0, size => 59 },
  "created_on",
  {
    data_type     => "timestamp with time zone",
    default_value => \"current_timestamp",
    is_nullable   => 0,
    original      => { default_value => \"now()" },
  },
  "updated_on",
  { data_type => "timestamp with time zone", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 entries

Type: has_many

Related object: L<Grimlock::App::Schema::Result::Entry>

=cut

__PACKAGE__->has_many(
  "entries",
  "Grimlock::App::Schema::Result::Entry",
  { "foreign.owner" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 user_roles

Type: has_many

Related object: L<Grimlock::App::Schema::Result::UserRole>

=cut

__PACKAGE__->has_many(
  "user_roles",
  "Grimlock::App::Schema::Result::UserRole",
  { "foreign.user" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 roles

Type: many_to_many

Composing rels: L</user_roles> -> role

=cut

__PACKAGE__->many_to_many("roles", "user_roles", "role");


# Created by DBIx::Class::Schema::Loader v0.07033 @ 2012-12-08 14:41:06
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:G9aTaZB49/ELETw2JDnyIg

has 'user' => (
  is       => 'ro',
  lazy     => 1,
  required => 1,
  default  => sub { shift }
);

with 'Grimlock::TraitFor::User::Credentials';

__PACKAGE__->add_columns(
  'password' => {
    data_type           => 'CHAR',
    size                => 59,
    encode_colun        => 1,
    encode_class        => 'Crypt::Eksblowfish::Bcrypt',
    encode_args         => { key_nul => 0, cost => 8 },
    encode_check_method => 'check_password',
  },
  'created_on',
  {
    data_type     => "timestamp with time zone",
    default_value => \"current_timestamp",
    is_nullable   => 0,
    set_on_create => 1,
    original      => { default_value => \"now()" },
  },
  "updated_on",
  { 
    data_type     => "timestamp with time zone", 
    is_nullable   => 1,
    set_on_create => 1,
    set_on_update => 1 
  },
);

sub insert {
  my ( $self, @args ) = @_;
  my $guard = $self->result_source->schema->txn_scope_guard;
  $self->next::method(@args);
  $self->add_to_roles({ name => 'user' });
  $guard->commit;
  return $self
}

# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
