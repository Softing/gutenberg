package Inprint::Access;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use utf8;
use strict;
use warnings;

use base 'Inprint::BaseController';

sub index {
    my $c = shift;
    my @terms     = $c->param("term");
    my $binding  = $c->param("binding");

    if ($binding eq 'domain') {
        $binding = '00000000-0000-0000-0000-000000000000';
    }

    my $result = {};

    foreach my $term (@terms) {
        my $exists = $c->access->Check($term, $binding);
        my ($prefix, $suffix) = split /:/, $term;
        if ( $exists ) {
            $result->{$prefix} = $c->json->true;
        } else {
            $result->{$prefix} = $c->json->false;
        }
    }

    return $c->render_json({
        success => $c->json->true,
        result  => $result
    });
}


1;
