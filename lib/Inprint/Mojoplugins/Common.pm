package Inprint::Mojoplugins::Common;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use warnings;
use strict;
use Mojo::Base 'Mojolicious::Plugin';

use Data::UUID;
use Mojo::JSON;

our $VERSION = '0.01';

our $JSON = Mojo::JSON->new;
our $UUID = new Data::UUID;

sub register {
    my ( $self, $app, $conf ) = @_;

    # Plugin config
    $conf ||= {};

    $app->helper(
        config => sub {
            my $c = shift;
            return $c->app->{config};
        } );

    $app->helper(
        json => sub {
            my $c = shift;
            return $JSON;
        } );

    $app->helper(
        uuid => sub {
            my $c = shift;
            return $UUID->create_str();
        } );

    $app->helper(
        redirect_to => sub {
            my $c = shift;

            $c->res->code(302);
            my $url = $c->url_for(@_)->to_rel;
            $url =~ s/\/index.pl//;

            $c->res->headers->location($url);
            return $c;
        } );


}

1;
