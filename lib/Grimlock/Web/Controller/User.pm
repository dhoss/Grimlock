package Grimlock::Web::Controller::User;
use Moose;
use namespace::autoclean;
use Try::Tiny;
use Data::Dumper;
use Chart::Clicker;
use Chart::Clicker::Context;
use Chart::Clicker::Data::DataSet;
use Chart::Clicker::Data::Marker;
use Chart::Clicker::Data::Series;
use Geometry::Primitive::Rectangle;
use Graphics::Color::RGB;
use Geometry::Primitive::Circle;
use DateTime;
use DateTime::Format::DBI;

BEGIN { extends 'Grimlock::Web::Controller::API' };

=head1 NAME

Grimlock::Web::Controller::User - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


has 'chart' => (
  is => 'ro',
  required => 1,
  lazy => 1,
  default => sub { Chart::Clicker->new }
);

sub BUILD {
  my $self = shift;
  $self->chart;
}
sub base : Chained('/api/base') PathPart('') CaptureArgs(0) {}

sub load_user : Chained('base') PathPart('user') CaptureArgs(1) {
  my ( $self, $c, $uid) = @_;
  my $user = $c->model('Database::User')->find(
    {
      name => $uid
    }, 
    {
      userid => $uid
    },
    { prefetch => 'entries' }
  );
  $c->log->debug("FOUND IN LOAD" . $user->name);
  $c->stash( user => $user );
}

sub list : Chained('base') PathPart('users') Args(0) ActionClass('REST'){
  my ( $self, $c ) = @_;
}

sub list_GET {
  my ( $self, $c ) = @_;
  $self->status_ok($c,
    entity => {
      users => [ $c->model('Database::User')->all ]
    },
  );
}

sub login  : Chained('base') PathPart('user/login') Args(0) ActionClass('REST') {
  my ( $self, $c, ) = @_;
  
  $c->stash( template => 'user/login.tt' );
}

sub login_GET  {
  my ( $self, $c ) = @_;
  return $self->status_ok($c, {
    entity => {
      user => $c->user->obj->userid
    }
  }) if $c->user_exists;
  
}

sub login_POST {
  my ( $self, $c ) = @_;
  my $params ||= $c->req->data || $c->req->params;
  if ( $c->authenticate({ 
        name => $params->{'name'},
        password => $params->{'password'}
      })
  ) {
        $c->res->redirect(
          $c->uri_for_action(
            '/user/browse', [ $c->user->obj->userid ]
          )
        );
  }

  $c->flash( message => "Incorrect credentials" );
  $c->res->redirect(
    $c->uri_for_action('/user/login')
  );
}

sub logout  : Chained('base') PathPart('user/logout') Args(0) ActionClass('REST') {
}

sub logout_GET {
  my ( $self, $c ) = @_;
  $c->logout;
  $self->status_ok($c,
    entity => { 
      message => "logged out successfully"
    }
  );
}

sub create : Chained('base') PathPart('user') Args(0) ActionClass('REST') {}

sub create_POST {
  my ( $self, $c ) = @_;
  my $params ||= $c->req->data || $c->req->params;
  my $user;
  try {

    $user = $c->model('Database::User')->create({
      name     => $params->{'name'},
      password => $params->{'password'},
      email    => $params->{'email'} || "",
    }) || die "Can't create user: $!";
    $c->set_authenticated($c->find_user({ name => $user->name}));
    
    return $self->status_created($c,
      location => $c->uri_for_action('/user/browse', [ $user->name ]),
      entity => {
        user => $user,
        message => "User created successfully!"
      }
    );
 
  } catch {

    return $self->status_bad_request($c,
      message => $_
    );
 
  };
 
}

sub browse : Chained('load_user') PathPart('') Args(0) ActionClass('REST') {
  my ( $self, $c ) = @_;
  my $user = $c->stash->{'user'} ;
  $c->stash( user => $user );
}

sub browse_GET {
  my ( $self, $c ) = @_;
  my $user = $c->stash->{'user'};  
  if ( !$user ) {
    return $self->status_bad_request($c,
      message => "Can't find user with that id"
    );
  }

  return $self->status_ok($c, 
    entity => {
      user => $user
    }
  );
}


sub browse_PUT {
  my ( $self, $c ) = @_;
  my $user = $c->stash->{'user'};
  return $self->status_bad_request($c, 
    message => "You don't have permission to modify this user"
  ) unless $user->has_role('admin') || ( $user->userid == $c->user->obj->userid );
  try { 
    my $params ||= $c->req->data || $c->req->params;
    my @columns = $user->columns;
     
    for my $column ( @columns ) {
      for my $key ( keys %{ $params } ) {  
        if ( defined $params->{$column} ) {
          $user->$column($params->{$key});
        }
      }
    }
    $user->update || die $!;
    return $self->status_ok($c, 
      entity => {
        user => $user 
      }
    );
  } catch {
    $self->status_bad_request($c, 
      message => $_
    );
  };
}

sub browse_DELETE {
  my ( $self, $c ) = @_;
  my $user = $c->stash->{'user'};
  return $self->status_bad_request($c,
    message => "you don't have permissions to do that"
  ) unless $user->has_role('admin') || ( $user->userid == $c->user->obj->userid );
  try {
    $user->delete || die $!;
    $self->status_ok($c,
      entity => {
        message => "Deleted user"
      }
    );
  } catch {
    $self->status_bad_request($c,
      message => $_
    );
  };
}

sub forgot_password : Chained('base') PathPart('forgot_password') Args(0) ActionClass('REST') {}

sub forgot_password_GET {
  my ( $self, $c ) = @_;
  return $self->status_ok( $c,
    entity => {}
  );
}

sub forgot_password_POST {
  my ( $self, $c ) = @_;
  my $params ||= $c->req->data || $c->req->params;
  my $email = $params->{'email'};
  if ( $email ) {
    my $user = $c->model('Database::User')->find({ email => $email }, { key => 'users_email' });
    $c->log->error("No such user $email") unless $user;
    my $new_pass = $user->generate_random_pass;
    $user->password($new_pass);
    $user->update;
    try {
      $c->model('Email')->send({
        from    => $c->config->{'Model::Email'}{'from'} || 'dhoss@mail.dhoss.net',
        to      => $user->email,
        subject => "New Password",
        body    => qq{
        Hi } . $user->name . qq{,
        Your new password is } . $new_pass
      }) || die "Can't send email $!";
      return $self->status_ok($c,
        entity => {
          message => "Your password has been sent."
      });
    } catch { 
      return $self->status_bad_request($c,
        message => $_
      );
    };

  } else {
    return $self->status_bad_request($c,
    message => "Email must be provided"
   );
 }
}


sub entries :  Chained('load_user') PathPart('entries') Args(0) ActionClass('REST') {
  my ( $self, $c ) = @_;

}

sub entries_GET {
  my ( $self, $c ) = @_;
  my $user = $c->stash->{'user'};
  my $entry_rs = $user->entries;
  return $self->status_ok($c,
    entity => {
      entries => [ $entry_rs->all ],
      user    => $user
    }
  );
}

sub manage_entries : Chained('load_user') PathPart('entries/manage') Args(0) ActionClass('REST') {
  my ( $self, $c ) = @_;

}

sub manage_entries_GET {
  my ( $self, $c ) = @_;
  my $user = $c->stash->{'user'};
  my $entry_rs = $user->entries;
  return $self->status_ok($c,
    entity =>{
      data_table => [ $entry_rs->all ],
    }
  );

}

sub list_drafts :  Chained('load_user') PathPart('drafts') Args(0) ActionClass('REST') {}

sub list_drafts_GET {
  my ( $self, $c ) = @_;
  my $user = $c->stash->{'user'};
  my $drafts = $user->drafts;
  return $self->status_ok($c,
    entity => {
      data_table => [$drafts->all]
    }
  );
}


sub stats : Chained('load_user') PathPart('stats') Args(0) ActionClass('REST') {}

sub stats_GET {
  my ( $self, $c ) = @_;
  my $user = $c->stash->{'user'};
  my $entries = $user->entries;
  my $chart = $self->chart;
  # this should go in a model
  my $date_diff = $user->date_range_for_stats;
  $c->log->debug("DATE DIFF " . $date_diff->days);
  my @dates;
  #push @dates, $today->subtract( days => 1 )->day for $date_diff->days;
  #$c->log->debug("DATES " . join ",", @dates);
  my @vals;
  push @vals, $_ for $entries->get_column('created_at')->all;
  $c->log->debug("VALUS " . Dumper \@vals);
  my $entry_series = Chart::Clicker::Data::Series->new(
    keys    =>      [ 1, 2, 3, 4, 5 ],
    values  =>      \@vals,
  );
  

  $c->stash(
    graphics_primitive => $chart,
    current_view_instance => 'View::Graphics'
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
