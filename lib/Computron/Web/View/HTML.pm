package Computron::Web::View::HTML;

use strict;
use base 'Catalyst::View::TT';

__PACKAGE__->config({
    PRE_PROCESS        => 'site/shared/base.tt',
    WRAPPER            => 'site/wrapper.tt',
    TEMPLATE_EXTENSION => '.tt',
    TIMER              => 0,
    static_root        => '/static',
    static_build       => 0
});

sub template_vars {
    my $self = shift;
    return (
        $self->NEXT::template_vars(@_),
        static_root  => $self->{static_root},
        static_build => $self->{static_build}
    );
}

=head1 NAME

Computron::Web::View::HTML - Catalyst TT::Bootstrap View

=head1 SYNOPSIS

See L<Computron::Web>

=head1 DESCRIPTION

Catalyst TT::Bootstrap View.

=head1 AUTHOR

Devin Austin

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
