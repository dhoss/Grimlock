use utf8;
package Grimlock::App::Schema::Result::EntryTag;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Grimlock::App::Schema::Result::EntryTag

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

=item * L<DBIx::Class::EncodedColumn>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime", "TimeStamp", "EncodedColumn");

=head1 TABLE: C<entry_tags>

=cut

__PACKAGE__->table("entry_tags");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'grimlock.entry_tags_id_seq'

=head2 name

  data_type: 'varchar'
  is_nullable: 1
  size: 200

=head2 entry

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "grimlock.entry_tags_id_seq",
  },
  "name",
  { data_type => "varchar", is_nullable => 1, size => 200 },
  "entry",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 entry

Type: belongs_to

Related object: L<Grimlock::App::Schema::Result::Entry>

=cut

__PACKAGE__->belongs_to(
  "entry",
  "Grimlock::App::Schema::Result::Entry",
  { id => "entry" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07033 @ 2012-10-25 08:56:13
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:TxSlbnz5Cupt47BgCHODXA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
