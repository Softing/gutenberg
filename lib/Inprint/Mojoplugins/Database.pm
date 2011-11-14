package Inprint::Mojoplugins::Database;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use warnings;
use strict;
use Mojo::Base 'Mojolicious::Plugin';

our $VERSION = '0.01';

sub register {
    my ( $self, $app, $conf ) = @_;

    # Plugin config
    $conf ||= {};

    $app->helper(
        dbh => sub {
            my $c = shift;
            return $c->app->{sql}->dbh;
        } );

    $app->helper(
        sql => sub {
            my $c = shift;
            return $c->app->{sql};
        } );

    $app->helper(
        Q => sub {
            my $c = shift;
            return $c->app->{sql}->Q(@_);
        } );

    $app->helper(
        Do => sub {
            my $c = shift;
            return $c->app->{sql}->Do(@_);
        } );

    $app->helper(
        txBegin => sub {
            my $c = shift;
            return $c->app->{sql}->bt;
        } );

    $app->helper(
        txCommit => sub {
            my $c = shift;
            return $c->app->{sql}->et;
        } );

    $app->helper(
        txRollback => sub {
            my $c = shift;
            return $c->app->{sql}->rt;
        } );

}

1;
