package Inprint::Catalog::Rules;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use base 'Inprint::BaseController';

sub list {

    my $c = shift;

    my $result = $c->sql->Q("
        SELECT t1.id, t1.rule, t1.name, t1.shortcut, t2.name as groupby
        FROM rules t1
            LEFT JOIN rules t2 ON t1.group = t2.rule
        WHERE t1.group is not null
        ORDER BY t2.sortorder, t1.shortcut, t1.name
    ")->Hashes;

    $c->render_json( { data => $result } );
}

sub assign {
    my $c = shift;
    return $c;
}

1;
