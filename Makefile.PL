#!/usr/bin/env perl
# IMPORTANT: if you delete this file your app will not work as
# expected.  You have been warned.
use inc::Module::Install;
use Module::Install::Catalyst; # Complain loudly if you don't have
                               # Catalyst::Devel installed or haven't said
                               # 'make dist' to create a standalone tarball.

name 'Grimlock-Web';
all_from 'lib/Grimlock/Web.pm';

requires 'Catalyst::Runtime' => '5.90007';
requires 'Catalyst::Plugin::ConfigLoader';
requires 'Catalyst::Plugin::Static::Simple';
requires 'Catalyst::Action::RenderView';
requires 'Moose';
requires 'Moo' => '0.009013';
requires 'namespace::autoclean';
requires 'Config::General'; # This should reflect the config file format you've chosen
                 # See Catalyst::Plugin::ConfigLoader for supported formats
requires 'Bread::Board';
requires 'DBIx::Class' => '0.08196';
requires 'Catalyst::Controller::REST';
requires 'Data::Manager';
requires 'Catalyst::Plugin::MessageStack';
requires 'Catalyst::Model::DBIC::Schema';
requires 'DBIx::Class::DeploymentHandler';
requires 'Catalyst::View::TT';
requires 'Catalyst::View::JSON';
requires 'Catalyst::Plugin::I18N';
requires 'Catalyst::Plugin::Authentication';
requires 'Catalyst::Plugin::Authorization::Roles';
requires 'Catalyst::Authentication::Store::DBIx::Class';
requires 'Catalyst::Plugin::Session';
requires 'Catalyst::Plugin::Session::Store::DBIC';
requires 'Catalyst::Plugin::Session::State::Cookie';
requires 'Catalyst::View::TT';
requires 'DBIx::Class::Candy';
requires 'DBIx::Class::EncodedColumn::Crypt::Eksblowfish::Bcrypt';
requires 'DBIx::Class::Helper::Row::ToJSON';
requires 'Text::Password::Pronounceable';
requires 'Email::Sender::Simple';
requires 'DBICx::MaterializedPath' => '0.03';
test_requires 'Test::More' => '0.88';
test_requires 'Test::WWW::Mechanize::PSGI' => '0.35';
catalyst;

install_script glob('script/*.pl');
auto_install;
WriteAll;
