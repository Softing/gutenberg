package Inprint::Catalog::Editions;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use base 'Inprint::BaseController';

sub tree {

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
            data => $item
        };

        if ( $item->{have_childs} ) {
            $record->{leaf} = $c->json->false;
            if ($i_node eq "root-node") {
                #$record->{expanded} = $c->json->true;
            }
        }

        push @$result, $record;
    }

    $c->render_json( $result );
}

sub create {
    my $c = shift;

    my $id            = $c->uuid();

    my $i_path        = $c->param("path");
    my $i_title       = $c->param("title");
    my $i_shortcut    = $c->param("shortcut");
    my $i_description = $c->param("description");

    my $result = {
        success => $c->json->false,
        errors => []
    };

    push @{ $result->{errors} }, { id => "path", msg => "" } unless $i_path;
    push @{ $result->{errors} }, { id => "title", msg => "" } unless $i_title;
    push @{ $result->{errors} }, { id => "shortcut", msg => "" } unless $i_shortcut;

    my $path;
    my $count = 0;

    unless (@{ $result->{errors} }) {
        $path = $c->sql->Q(" SELECT path FROM editions WHERE id =? ",
        [ $i_path ])->Value;
    }

    push @{ $result->{errors} }, { id => "path", msg => "" } unless $path;

    unless (@{ $result->{errors} }) {
        $count = $c->sql->Do("
            INSERT INTO editions (id, title, shortcut, description, path, type, capables)
                VALUES (?, ?, ?, ?, replace(?, '-',  '')::ltree, ?, ?)
        ", [ $id, $i_title, $i_shortcut, $i_description, "$path.$id", 'default', [] ]);
    }

    $result->{success} = $c->json->true if $count;

    $c->render_json( $result );
}


sub read {
    my $c = shift;
    my $i_id            = $c->param("id");
    my $result = {
        success => $c->json->false,
        errors => []
    };
    push @{ $result->{errors} }, { id => "id", msg => "" } unless $i_id;
    $result->{data} = $c->sql->Q("
        SELECT t1.*,
            subpath(path, -2,1) as parent,
            (select shortcut from editions where subpath(path, -1,1) = subpath(t1.path, -2,1) ) as parent_shortcut
        FROM editions t1 WHERE t1.id = ?
    ", [ $i_id ])->Hash;
    $result->{success} = $c->json->true if $result->{data};
    $c->render_json( $result );
}

sub update {
    my $c = shift;

    my $i_id          = $c->param("id");
    my $i_path        = $c->param("path");
    my $i_title       = $c->param("title");
    my $i_shortcut    = $c->param("shortcut");
    my $i_description = $c->param("description");

    my $result = {
        success => $c->json->false,
        errors => []
    };

    push @{ $result->{errors} }, { id => "id", msg => "" } unless $i_id;
    push @{ $result->{errors} }, { id => "path", msg => "" } unless $i_path;
    push @{ $result->{errors} }, { id => "title", msg => "" } unless $i_title;
    push @{ $result->{errors} }, { id => "shortcut", msg => "" } unless $i_shortcut;

    my $path;
    my $count = 0;

    unless (@{ $result->{errors} }) {
        $path = $c->sql->Q(" SELECT path FROM editions WHERE id =? ",
        [ $i_path ])->Value;
    }

    push @{ $result->{errors} }, { id => "path", msg => "" } unless $path;

    unless (@{ $result->{errors} }) {
        $count = $c->sql->Do(" UPDATE editions SET title=?, shortcut=?, description=?, path=replace(?, '-',  '')::ltree WHERE id=? ",
            [ $i_title, $i_shortcut, $i_description, "$path.$i_id", $i_id ]);
    }

    $result->{success} = $c->json->true if $count;

    $c->render_json( $result );
}

sub delete {
    my $c = shift;

    my $id = $c->param("id");

    $c->sql->Do(" DELETE FROM editions WHERE id =? ", [ $id ]);

    $c->render_json( { } );
}

1;
