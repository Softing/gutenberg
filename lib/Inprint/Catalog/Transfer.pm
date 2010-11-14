package Inprint::Catalog::Transfer;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use base 'Inprint::BaseController';

sub editions {

    my $c = shift;

    my $i_node = $c->param("node");

    my $data = [];

    if ($i_node eq "root-node") {
        $data = $c->sql->Q("
            SELECT *, ( SELECT count(*) FROM editions c2 WHERE c2.path ~ ('00000000000000000000000000000000.*{1}')::lquery ) as have_childs
            FROM editions
            WHERE
                id = '00000000-0000-0000-0000-000000000000'
            ORDER BY shortcut
        ")->Hashes;
    } else {
        $data = $c->sql->Q("
            SELECT *, ( SELECT count(*) FROM editions c2 WHERE c2.path ~ ('*.' || replace(?, '-', '')::text || '.*{2}')::lquery ) as have_childs
            FROM editions
            WHERE
                id <> '00000000-0000-0000-0000-000000000000'
                AND subpath(path, nlevel(path) - 2, 1)::text = replace(?, '-', '')::text
            ORDER BY shortcut
        ", [ $i_node, $i_node ])->Hashes;
    }

    my $result = [];

    foreach my $item (@$data) {

        my $record = {
            id   => $item->{id},
            text => $item->{shortcut},
            leaf => $c->json->true,
            icon => "book",
            data => $item
        };

        if ( $item->{have_childs} ) {
            $record->{leaf} = $c->json->false;
        }

        push @$result, $record;
    }

    $c->render_json( $result );
}

sub branches {

    my $c = shift;

    my $result = [];

    my $i_node = $c->param("node");

    my $branch = $c->sql->Q(" SELECT id FROM branches WHERE edition=? LIMIT 1 ", [ $i_node ])->Value;

    my $data = $c->sql->Q("
        SELECT t1.id, t1.branch, t1.readiness, t1.weight, t1.title, t1.shortcut, t1.description,
            t2.shortcut as readiness_shortcut, t2.color as readiness_color
        FROM stages t1, readiness t2
        WHERE t1.branch=? AND t1.readiness=t2.id
        ORDER BY t1.weight, t1.shortcut
    ", [ $branch ])->Hashes || [];

    foreach my $item (@$data) {

        my $record = {
            id    => $item->{id},
            text  => $item->{shortcut},
            leaf  => $c->json->true,
            icon  => "tag-label",
            color => $item->{color},
            data  => $item
        };

        #if ( $item->{have_childs} ) {
        #    $record->{leaf} = $c->json->false;
        #}

        push @$result, $record;
    }

    $c->render_json( $result );
}

sub list {

    my $c = shift;

    my $i_stage = $c->param("node");

    my $result = $c->sql->Q("
        SELECT t1.id, t1.stage, t1.catalog, t1.principal,
            t2.shortcut as catalog_shortcut,
            t3.shortcut as stage_shortcut,
            t4.type,
            t4.shortcut as title,
            t4.description
        FROM map_principals_to_stages t1, catalog t2, stages t3, view_principals t4
        WHERE stage=?
            AND t1.catalog = t2.id
            AND t1.stage = t3.id
            AND t1.principal = t4.id
        ORDER BY t4.type, t4.shortcut
    ", [ $i_stage ])->Hashes;

    $c->render_json( { data => $result || [] } );
}

1;