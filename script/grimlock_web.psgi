#!/usr/bin/env perl
use strict;
use warnings;
use Grimlock::Web;

my $app = Grimlock::Web->apply_default_middlewares->psgi_app(@_);

