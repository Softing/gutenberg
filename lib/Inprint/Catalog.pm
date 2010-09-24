package Inprint::Catalog;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use base 'Inprint::BaseController';

sub tree {

    my $c = shift;

    my $node = $c->param("node");

    my $data = $c->sql->Q(
        " SELECT *, not exists (SELECT true FROM catalog_tree WHERE depth =1 AND parent = catalog.id ) as leaf
            FROM catalog WHERE parent = ?
            ORDER BY shortcut
        ", [$node])->Hashes;

    my $result = [];

    foreach my $item (@$data) {
        push @$result, {
            id   => $item->{id},
            text => $item->{shortcut},
            leaf => $item->{leaf},
            data => $item
        };
    }

    $c->render_json( $result );
}

sub combo {
    my $c = shift;
    my $result = $c->sql->Q("
        SELECT
            t1.id, t1.name, t1.shortcut, t1.description,
            repeat('&nbsp;', t2.depth * 2) || '- ' || t1.shortcut as path
        FROM catalog t1, catalog_tree t2
        WHERE
            t2.parent = '00000000-0000-0000-0000-000000000000' AND t2.child = t1.id
        ORDER BY named_path, t1.shortcut
    ")->Hashes;

    $c->render_json( { data => $result } );
}

sub create {
    my $c = shift;

    my $id            = $c->uuid();

    my $i_name        = $c->param("name");
    my $i_shortcut    = $c->param("shortcut");
    my $i_description = $c->param("description");
    my $i_path        = $c->param("path");

    $c->sql->Do("
        INSERT INTO catalog (id, parent, name, shortcut, description, type, capables)
            VALUES (?,?,?,?,?,?,?)
    ", [ $id, $i_path, $i_name, $i_shortcut, $i_description, 'default', [] ]);

    $c->render_json( { } );
}

sub delete {
    my $c = shift;

    my $id = $c->param("id");

    $c->sql->Do(" DELETE FROM catalog WHERE id =? ", [ $id ]);

    $c->render_json( { } );
}

1;
