package Inprint::Fascicle::Documents;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use Inprint::Models::Documents;

use base 'Inprint::BaseController';

sub list {
    my $c = shift;

    my $searchResult = Inprint::Models::Documents::search($c, {
        baseSort => 'headline_shortcut'
    });

    $c->render_json( { "data" => $searchResult->{result}, "total" => $searchResult->{total} } );
}

1;
