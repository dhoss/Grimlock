package Grimlock::Web::Controller::Entry;
use Moose;
use namespace::autoclean;
use Try::Tiny;

BEGIN {extends 'Grimlock::Web::Controller::API'; }

=head1 NAME

Grimlock::Web::Controller::Entry - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


sub base : Chained('/api/base') PathPart('') CaptureArgs(0) {}

sub load_entry : Chained('base') PathPart('') CaptureArgs(1) {
  my ( $self, $c, $entry_title ) = @_;
  my $entry = $c->model('Database::Entry')->find(
  {
    display_title => $entry_title 
  });
  $c->stash( entry => $entry );
}


sub create : Chained('base') PathPart('entry') Args(0) ActionClass('REST') {
  my ( $self, $c ) = @_;
  return $self->status_bad_request($c,
    message => "You must be logged in to create an entry"
  ) unless $c->user_exists;
}

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
  my $entry;
  try {
    $entry = $user->create_related('entries', {
        title => $params->{'title'},
        body  => $params->{'body'}
    }) || die $!;
 
    $self->status_created($c, 
      location => $c->req->uri->as_string,
      entity   => {
        entry => $entry
      }
    );
  } catch {
    return $self->status_bad_request($c,
      message => $_
    );
  };
}

sub reply : Chained('load_entry') PathPart('reply') Args(0) ActionClass('REST') {
  my ( $self, $c ) = @_;
  my $entry = $c->stash->{'entry'};
  return $self->status_bad_request($c,
    message => "No such post"
  ) unless $entry;
}

sub reply_GET {
  my ( $self, $c ) = @_;
  
  $self->status_ok($c, 
    entity => {}
  );
}

sub reply_POST {
  my ( $self, $c ) = @_;
  my $params ||= $c->req->data || $c->req->params;
  my $entry = $c->stash->{'entry'};
  my $reply;
  try {
    $reply = $entry->create_related('children', {
      parent => $entry,
      title => $params->{'title'},
      body => $params->{'body'}
    }) or die $!;
    return $self->status_created($c,
      location => $c->uri_for_action('/entry/browse', [ $reply->entryid ] ),
      entity   => {
        reply => $reply
      }
    );
  } catch {
    $self->status_bad_request($c,
      message => $_
    );
  };
}
      

sub browse : Chained('load_entry') PathPart('') Args(0) ActionClass('REST') {
  my ( $self, $c ) = @_;
  my $entry = $c->stash->{'entry'};
  return $self->status_bad_request($c,
    message => "No such post"
  ) unless $entry;
}

sub browse_GET {
  my ( $self, $c ) = @_;
  my $entry = $c->stash->{'entry'};
  return $self->status_ok($c,
    entity => {
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
