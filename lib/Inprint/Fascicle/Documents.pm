package Inprint::Fascicle::Documents;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use Inprint::Models::Documents;

use base 'Mojolicious::Controller';

sub list {
    my $c = shift;

    my $searchResult = Inprint::Models::Documents::search($c, {
        baseSort => 'headline_shortcut'
    });

    $c->render_json( { "data" => $searchResult->{result}, "total" => $searchResult->{total} } );
}

1;
