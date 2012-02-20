package Grimlock::Schema::Migrations;

use Moose;
use namespace::autoclean;
use Directory::Scratch;
use SQL::Translator;
use SQL::Translator::Diff;
use SQL::Translator::Schema::Constants;
use POSIX qw(strftime);
use Carp qw( croak );


BEGIN { $_=1 };

has [ qw( schema source target ) ] => (
  is => 'rw',
  required => 1,
  lazy => 1,
  default => sub { shift->usage }
);

has '_tmp_dir' => (
  is => 'ro',
  lazy => 1,
  required => 1,
  default => sub { Directory::Scratch->new }
);

has 'old_dir' => (
  is => 'ro',
  required => 1,
  lazy => 1,
  default => 


__PACKAGE__->meta->make_immutable;
1;
