package Grimlock::App::Container;
use Moose;
use Bread::Board::Declare;
use Config::JFDI;
use Path::Class qw(dir);

has 'config' => (
  is     => 'ro',
  isa    => 'HashRef',
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
    my $db_credentials = $self->param('config')->{'Model::Database'}{'connect_info'};
    Grimlock::App::Schema->connect( 
      delete $db_credentials->{'dsn'},
      delete $db_credentials->{'user'}, 
      delete $db_credentials->{'password'} 
      { %{ $db_credentials } }
    );
  }
);
  

__PACKAGE__->meta->make_immutable;
1;
