package Grimlock::ScrubsEntry;

use Moo::Role;
use HTML::Scrubber;

has 'scrubber' => (
  is => 'ro',
  isa => 'HTML::Scrubber',
  required => 1,
  lazy => 1,
  builder => '_build_scrubber',
  handles => [qw( scrub deny )],
);


sub _build_scrubber {
  my $self = shift;
  return HTML::Scrubber->new( allow => [ qw[ p b i u hr br ] ] );
}

1;
