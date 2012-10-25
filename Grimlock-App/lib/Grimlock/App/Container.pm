package Grimlock::App::Container;
use Moose;
use Bread::Board::Declare;
use Config::JFDI;
use Path::Class qw(dir);

has 'config' => (
  is     => 'ro',
  isa    => 'Config::JFDI',
  block  => sub {
    my $cfg = Config::JFDI->new( name => 'grimlock', path => dir('.') );
    return $cfg->get;
  }
);

has 'schema' => (
  is           => 'ro',
  isa          => 'Grimlock::App::Schema',
  dependencies => ['config'],
  lifecycle    => 'Singleton',
  block        => sub {
    my $self = shift;
    Grimlock::App::Schema->connect( @{$self->config->{'Model::Database'}{connect_info}} );
  }
);
  

__PACKAGE__->meta->make_immutable;
1;
