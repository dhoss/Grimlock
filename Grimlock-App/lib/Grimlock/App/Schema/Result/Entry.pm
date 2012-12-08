use utf8;
package Grimlock::App::Schema::Result::Entry;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grimlock::App::Schema::Result::Entry

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

=head1 TABLE: C<entries>

=cut

__PACKAGE__->table("entries");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'entries_id_seq'

=head2 title

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 body

  data_type: 'text'
  is_nullable: 0

=head2 created_on

  data_type: 'timestamp with time zone'
  default_value: current_timestamp
  is_nullable: 0
  original: {default_value => \"now()"}

=head2 updated_on

  data_type: 'timestamp with time zone'
  is_nullable: 1

=head2 owner

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 parent_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 parent_path

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "entries_id_seq",
  },
  "title",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "body",
  { data_type => "text", is_nullable => 0 },
  "created_on",
  {
    data_type     => "timestamp with time zone",
    default_value => \"current_timestamp",
    is_nullable   => 0,
    original      => { default_value => \"now()" },
  },
  "updated_on",
  { data_type => "timestamp with time zone", is_nullable => 1 },
  "owner",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "parent_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "parent_path",
  { data_type => "varchar", is_nullable => 1, size => 255 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 UNIQUE CONSTRAINTS

=head2 C<entries_title_key>

=over 4

=item * L</title>

=back

=cut

__PACKAGE__->add_unique_constraint("entries_title_key", ["title"]);

=head1 RELATIONS

=head2 entries

Type: has_many

Related object: L<Grimlock::App::Schema::Result::Entry>

=cut

__PACKAGE__->has_many(
  "entries",
  "Grimlock::App::Schema::Result::Entry",
  { "foreign.parent_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 entry_tags

Type: has_many

Related object: L<Grimlock::App::Schema::Result::EntryTag>

=cut

__PACKAGE__->has_many(
  "entry_tags",
  "Grimlock::App::Schema::Result::EntryTag",
  { "foreign.entry" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 owner

Type: belongs_to

Related object: L<Grimlock::App::Schema::Result::User>

=cut

__PACKAGE__->belongs_to(
  "owner",
  "Grimlock::App::Schema::Result::User",
  { id => "owner" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);

=head2 parent

Type: belongs_to

Related object: L<Grimlock::App::Schema::Result::Entry>

=cut

__PACKAGE__->belongs_to(
  "parent",
  "Grimlock::App::Schema::Result::Entry",
  { id => "parent_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07033 @ 2012-12-08 14:41:06
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:NiEyAYXyA0nVmIkIP68gFg


__PACKAGE__->load_components('MaterializedPath');
__PACKAGE__->belongs_to( parent_entry  => 'Grimlock::App::Schema::Result::Entry', 'parent_id' );
__PACKAGE__->has_many(   child_entries => 'Grimlock::App::Schema::Result::Entry', 'parent_id' );

# not sure why this isn't working
__PACKAGE__->belongs_to(
  "owner",
  "Grimlock::App::Schema::Result::User",
  { id => "owner" },
  { is_deferrable => 0, on_delete => "CASCADE", on_update => "CASCADE" },
);

sub materialized_path_columns {
   return {
      parent => {
         parent_column                => 'parent_id',
         parent_fk_column             => 'id',
         materialized_path_column     => 'parent_path',
         include_self_in_path         => 1,
         include_self_in_reverse_path => 1,
         separator                    => '.',
         parent_relationship          => 'parent_entry',
         children_relationship        => 'child_entries',
         full_path                    => 'ancestors',
         reverse_full_path            => 'descendants',
      },
   }
}

# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
