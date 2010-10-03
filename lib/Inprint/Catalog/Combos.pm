package Inprint::Catalog::Combos;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use base 'Inprint::BaseController';

sub groups {
    my $c = shift;
    my $result = $c->sql->Q("
        SELECT t1.id, t1.shortcut as title, nlevel(path) as nlevel, '' as description,
            array_to_string( ARRAY( SELECT shortcut FROM catalog WHERE path @> t1.path ORDER BY nlevel(path) ), '.') as title_path
        FROM catalog t1
        ORDER BY title_path
    ")->Hashes;
    $c->render_json( { data => $result } );
}

sub editions {
    my $c = shift;
    my $result = $c->sql->Q("
        SELECT t1.id, t1.shortcut as title, nlevel(path) as nlevel, '' as description,
            array_to_string( ARRAY( SELECT shortcut FROM editions WHERE path @> t1.path ORDER BY nlevel(path) ), '.') as title_path
        FROM editions t1
        ORDER BY title_path
    ")->Hashes;
    $c->render_json( { data => $result } );
}

sub roles {
    my $c = shift;
    my $sql = " SELECT id, title, shortcut, description FROM fascicles WHERE 1=1 ";
    $sql .= " ORDER BY issystem DESC, enddate, title ";
    my $result = $c->sql->Q($sql)->Hashes;
    $c->render_json( { data => $result } );
}

1;
