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
    display_title => $entry_title,
  },
  {
    prefetch => 'children'
  });
  $c->stash( entry => $entry );
}


sub create : Chained('base') PathPart('entry') Args(0) ActionClass('REST') {
  my ( $self, $c ) = @_;
}

sub create_GET {
  my ( $self, $c ) = @_;
  unless ( $c->user_exists ) {
    return $self->status_bad_request($c,
      message => "You must be logged in to create an entry"
    );
  }
  my $user = $c->user;
  $self->status_ok( $c, entity => {} );
}

sub create_POST {
  my ( $self, $c ) = @_;
  unless ( $c->user_exists ) {
    return $self->status_bad_request($c,
      message => "You must be logged in to create an entry"
    );
  }
  my $params = $c->req->data || $c->req->params;
  my $user = $c->user->obj;
  my $entry;
  try {
    $params->{'published'} = 1 if $params->{'published'} eq 'on';
    $c->log->debug('LOGGED IN AS ' . $user->name);
    $entry = $user->create_entry($params) || die $!;

    $self->status_created($c,
      location => $c->req->uri->as_string,
      entity   => {
        message => "Entry created!",
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
}

sub reply_GET {
  my ( $self, $c ) = @_;
  my $entry = $c->stash->{'entry'};
  return $self->status_bad_request($c,
    message => "No such post"
  ) unless $entry;

  return $self->status_ok($c,
    entity => {
      entry => $entry
    }
  );
}

sub reply_POST {
  my ( $self, $c ) = @_;
  my $params ||= $c->req->data || $c->req->params;
  my $entry = $c->stash->{'entry'};
  return $self->status_bad_request($c,
    message => "No such post"
  ) unless $entry;

  my $reply;
  try {

    my $title = "RE:" . $entry->title . rand;
    $reply = $c->model('Database::Entry')->create({
      author => $c->user->obj->userid,
      parent => $entry,
      title => $title,
      body => $params->{'body'},
      published => 1,
    }) or die $!;

    return $self->status_created($c,
      location => $c->uri_for_action('/entry/browse', [ $reply->display_title ] ),
      entity   => {
        message => "Reply posted!",
        reply => $reply,
        entry => $reply->parent
      }
    );

  } catch {
    return $self->status_bad_request($c,
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

sub browse_PUT {
  my ( $self, $c ) = @_;
  my $params = $c->req->data || $c->req->params;

  my $entry = $c->stash->{'entry'} ?
              $c->stash->{'entry'} :
              $c->user->entries->find($params->{'entryid'});
  $params->{'published'} = $params->{'published'} eq 'on' ? 1 : 0;
  delete $params->{$_} for qw( frmInsertFlag frmRecord );
  # dirty hack to update the display_title column if the title column
  # gets changed
  $params->{'display_title'} = $params->{'title'};
  $entry->update($params) || return $self->status_bad_request($c,
    message => "Couldn't update entry; $!"
  );

   return $self->status_created($c,
    location => $c->uri_for_action('/entry/browse', [ $entry->display_title ]),
    entity => {
      entry => $entry
    }
  );
}

sub browse_DELETE {
  my ( $self, $c ) = @_;
  my $entry = $c->stash->{'entry'};
  $entry->delete || return $self->status_bad_request($c,
    message => "Couldn't delete entry: $!"
  );

  return $self->status_ok($c,
    entity => {
      deleted => 1
    }
  );
}


sub list : Chained('base') PathPart('') Args(0) ActionClass('REST') {}

sub list_GET {
  my ( $self, $c ) = @_;
  my $params = $c->req->data || $c->req->params;
  my $page = $params->{'page'} =~ /\d+/ ?
             $params->{'page'}          :
             1;
  return $self->status_ok($c,
    entity => {
      entries => [ $c->model('Database::Entry')->published(
        {
          page => $page
        }
      )]
    },
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
