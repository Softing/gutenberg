package Inprint::Common::Transfer;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;



use base 'Mojolicious::Controller';

sub editions {
     my $c = shift;

    my $i_node = $c->param("node");
    $i_node = '00000000-0000-0000-0000-000000000000' unless ($i_node);
    $i_node = '00000000-0000-0000-0000-000000000000' if ($i_node eq "root-node");

    my @result;
    my @errors;
    my $success = $c->json->false;

    $c->check_uuid( \@errors, "id", $i_node);

    unless (@errors) {

        my $sql;
        my @data;

        my $bindings = $c->objectBindings("editions.documents.work:*");

        if ($i_node eq "00000000-0000-0000-0000-000000000000") {
            $sql = "
                SELECT t1.*,
                    ( SELECT count(*) FROM editions c2 WHERE c2.path ~ ('*.' || t1.path::text || '.*{1}')::lquery ) as have_childs
                FROM editions t1
                WHERE
                    t1.id <> '00000000-0000-0000-0000-000000000000'
                    AND t1.id = ANY(?)
            ";
            push @data, $bindings;
        }

        if ($i_node ne "00000000-0000-0000-0000-000000000000") {
            $sql .= "
                SELECT t1.*,
                    ( SELECT count(*) FROM editions c2 WHERE c2.path ~ ('*.' || t1.path::text || '.*{1}')::lquery ) as have_childs
                FROM editions t1
                WHERE
                    t1.id <> '00000000-0000-0000-0000-000000000000'
                    AND subpath(t1.path, nlevel(t1.path) - 2, 1)::text = replace(?, '-', '')::text
                    AND t1.id = ANY(?)
                ";
            push @data, $i_node;
            push @data, $bindings;
        }

        my $data = $c->Q("$sql ORDER BY shortcut", \@data)->Hashes;

        foreach my $item (@$data) {
            my $record = {
                id   => $item->{id},
                text => $item->{shortcut},
                leaf => $c->json->true,
                icon => "blue-folders",
                data => $item
            };
            if ( $item->{have_childs} ) {
                $record->{leaf} = $c->json->false;
            }
            push @result, $record;
        }
    }

    $success = $c->json->true unless (@errors);

    $c->render_json( \@result );
}

sub branches {

    my $c = shift;

    my $result = [];

    my $i_node = $c->param("node");

    my $branch = $c->Q(" SELECT id FROM branches WHERE edition=? LIMIT 1 ", [ $i_node ])->Value;

    my $data = $c->Q("
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

    my $result = $c->Q("
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
