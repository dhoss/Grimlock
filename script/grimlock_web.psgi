#!/usr/bin/env perl
use strict;
use warnings;
use Grimlock::Web;

my $app = Grimlock::Web->psgi_app(@_);

