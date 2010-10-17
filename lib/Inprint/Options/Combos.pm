package Inprint::Options::Combos;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use base 'Inprint::BaseController';

sub captureDestination {

    my $c = shift;

    my $result = $c->sql->Q("
        SELECT t1.id, t1.stage, t1.catalog, t4.weight || '% - ' || t2.shortcut || '/' || t3.shortcut as title, t4.color
        FROM map_principals_to_stages t1, stages t2, catalog t3, readiness t4
        WHERE t2.id = t1.stage AND t3.id = t1.catalog AND t4.id = t2.readiness
            AND t1.principal=?
        ORDER BY t4.weight, title
    ", [ $c->QuerySessionGet("member.id") ])->Hashes;

    $c->render_json( { data => $result } );
}

1;
