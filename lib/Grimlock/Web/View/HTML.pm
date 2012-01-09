package Grimlock::Web::View::HTML;

use strict;
use base 'Catalyst::View::TT';
use Grimlock::Web;
use Data::Dumper;
__PACKAGE__->config({
    PRE_PROCESS        => 'shared/base.tt',
    WRAPPER            => 'wrapper.tt',
    TEMPLATE_EXTENSION => '.tt',
    INCLUDE_PATH       => [
      Grimlock::Web->path_to('root','site')
    ],
    TIMER              => 0,
    static_root        => '/static',
    static_build       => 0,
    render_die => 1
});

sub template_vars {
    my $self = shift;
    return (
        $self->NEXT::template_vars(@_),
        static_root  => $self->{static_root},
        static_build => $self->{static_build}
    );
}

sub process {
    my ( $self, $c, $stash_key ) = @_;
    my $output;
    eval {
        $output = $self->serialize( $c, $c->stash->{$stash_key} );
    };
    return $@ if $@;
 
    $c->response->body( $output );
    return 1;  # important
}

sub serialize {
    my ( $self, $c, $data ) = @_;
    my $template = $c->stash->{'template'} || $c->action . ".tt";
    my $view = $c->view('HTML');
    my $serialized = $view->render($c, $template, $data) || die $view->tt_error;
 
    return $serialized;
}


=head1 NAME

Grimlock::Web::View::HTML - Catalyst TT::Bootstrap View

=head1 SYNOPSIS

See L<Grimlock::Web>

=head1 DESCRIPTION

Catalyst TT::Bootstrap View.

=head1 AUTHOR

Devin Austin

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
