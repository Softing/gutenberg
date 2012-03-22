package Inprint::Mojoplugins::Session;

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
        getSessionValue => sub {
            my $c = shift;
            my $param_name = shift;
            return $c->stash( "querySession.$param_name" );
        } );

    $app->helper(
        setSessionValue => sub {
            my $c = shift;
            my $param_name = shift;
            my $param_value = shift;
            $c->stash( "querySession.$param_name" => $param_value );
            return $c;
        } );

}

1;
