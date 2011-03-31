package Inprint::BaseController;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use utf8;
use strict;
use warnings;

use base 'Mojolicious::Controller';

sub redirect_to {

    my $c = shift;

    $c->res->code(302);
    my $url = $c->url_for(@_)->to_rel;
    $url =~ s/\/index.pl//;

    $c->res->headers->location($url);
    return $c;
}

1;
