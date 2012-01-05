package Grimlock::Web::Model::Email;
use Moose;
use namespace::autoclean;
use Email::Sender::Simple qw(sendmail);
use Email::Simple;
use Email::Simple::Creator;
use Carp qw( croak );

has 'email' => (
  is => 'rw',
  required => 1,
  lazy => 1,
  default => sub { croak "Email message required" }
);

sub create {
  my ( $self, $params ) = @_;
  
  $self->email(Email::Simple->create(
    header => [
      To => $params->{'to'},
      From => $params->{'from'},
      Subject => $params->{'subject'},
    ],
    body => $params->{'body'}
  ));
  warn "CREATED EMAIL";
  return $self
  
}

sub send {
  my $self = shift;
  sendmail($self->email);
  warn "EMAIL SENT";
}

1;
