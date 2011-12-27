package Grimlock::Web::Controller::Entry;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Grimlock::Web::Controller::API'; }

=head1 NAME

Grimlock::Web::Controller::Entry - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched Grimlock::Web::Controller::Entry in Entry.');
}


sub create : Chained('/api/base') PathPart('entry') Args(0) {}

sub create_GET {
  my ( $self, $c ) = @_;
 
  $self->status_ok({
    $c, entity => {}
  });
}

sub create_POST { 
  my ( $self, $c ) = @_;
   
  my $params = $c->req->data || $c->req->params;
  my $user = $c->user->obj;
  my $entry = $user->create_related('entries', {
      title => $params->{'title'},
      body  => $params->{'body'}
  });

  $self->status_created($c, 
    location => $c->req->uri->as_string,
    entity   => {
      entry => $entry
    }
  );
}

=head1 AUTHOR

Devin Austin

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;