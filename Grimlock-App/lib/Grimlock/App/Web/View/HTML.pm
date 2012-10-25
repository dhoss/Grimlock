package Grimlock::App::Web::View::HTML;

use Moose;
extends 'Catalyst::View::Xslate';

has '+module' => (
    default => sub { [ 'Text::Xslate::Bridge::TT2Like' ] }
);

__PACKAGE__->meta->make_immutable;
1;
