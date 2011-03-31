package Inprint::Mojoplugins::Database;

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
            return $c->app->dbh;
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

}

1;
