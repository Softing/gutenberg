package Inprint::Advertising::Common;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use utf8;
use strict;
use warnings;

use base 'Inprint::BaseController';

sub editions {

    my $c = shift;

    my $i_node = $c->param("node");
    $i_node = '00000000-0000-0000-0000-000000000000' unless ($i_node);
    $i_node = '00000000-0000-0000-0000-000000000000' if ($i_node eq "root-node");

    my @errors;
    my $success = $c->json->false;

    push @errors, { id => "id", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_node));

    my @result;

    unless (@errors) {
        my $sql;
        my @data;

        $sql = "
            SELECT edition1.id, 'edition' as type, edition1.id as edition, edition1.shortcut as text, 'blue-folders-stack' as icon,
                (
                    EXISTS( SELECT * FROM editions WHERE path <@ edition1.path AND id <> edition1.id )
                )
                as have_childs
            FROM editions as edition1
            WHERE
                edition1.id <> '00000000-0000-0000-0000-000000000000'
                AND subpath(edition1.path, nlevel(edition1.path) - 2, 1)::text = replace(?, '-', '')::text
            ORDER BY edition1.shortcut
        ";
        push @data, $i_node;

        my $data = $c->sql->Q("$sql", \@data)->Hashes;

        foreach my $item (@$data) {
            my $record = {
                id   => $item->{id},
                text => $item->{text},
                icon => $item->{icon},
                type => $item->{type},
            };
            if ( $item->{have_childs} ) {
                $record->{leaf} = $c->json->false;
            } else {
                $record->{leaf} = $c->json->true;
            }
            push @result, $record;
        }
    }

    $success = $c->json->true unless (@errors);

    $c->render_json( \@result );
}

sub fascicles {

    my $c = shift;

    my $i_node = $c->param("node");
    $i_node = '00000000-0000-0000-0000-000000000000' unless ($i_node);
    $i_node = '00000000-0000-0000-0000-000000000000' if ($i_node eq "root-node");

    my @errors;
    my $success = $c->json->false;

    push @errors, { id => "id", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_node));

    my @result;

    unless (@errors) {
        my $sql;
        my @data;

        $sql = "
            (
                SELECT edition1.id, 'edition' as type, edition1.id as edition, null as fascicle, edition1.shortcut as text, 'blue-folders-stack' as icon,
                    (
                        EXISTS( SELECT * FROM editions WHERE path <@ edition1.path AND id <> edition1.id )
                        OR
                        EXISTS( SELECT true FROM fascicles WHERE fascicles.edition = edition1.id AND fascicles.is_system = false AND fascicles.is_enabled = true  )
                    )
                    as have_childs
                FROM editions as edition1
                WHERE
                    edition1.id <> '00000000-0000-0000-0000-000000000000'
                    AND subpath(edition1.path, nlevel(edition1.path) - 2, 1)::text = replace(?, '-', '')::text
                ORDER BY edition1.shortcut
            ) UNION ALL (
                SELECT id, 'fascicle' as type, edition, id as fascicle, shortcut as text, 'blue-folder-open-document-text' as icon,
                    false as have_childs
                FROM fascicles
                WHERE is_system = false AND is_enabled = true AND edition = ?
                ORDER BY shortcut
            )
        ";
        push @data, $i_node;
        push @data, $i_node;

        my $data = $c->sql->Q("$sql", \@data)->Hashes;

        foreach my $item (@$data) {
            my $record = {
                id   => $item->{id},
                text => $item->{text},
                leaf => $item->{have_childs},
                icon => $item->{icon},
                type => $item->{type},

                edition  => $item->{edition},
                fascicle => $item->{fascicle},
            };
            if ( $item->{have_childs} ) {
                $record->{leaf} = $c->json->false;
            } else {
                $record->{leaf} = $c->json->true;
            }
            push @result, $record;
        }
    }

    $success = $c->json->true unless (@errors);

    $c->render_json( \@result );
}

sub places {

    my $c = shift;

    my $i_node = $c->param("node");
    $i_node = '00000000-0000-0000-0000-000000000000' unless ($i_node);
    $i_node = '00000000-0000-0000-0000-000000000000' if ($i_node eq "root-node");

    my @errors;
    my $success = $c->json->false;

    push @errors, { id => "id", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_node));

    my @result;

    unless (@errors) {
        my $sql;
        my @data;

        $sql = "
            (
                SELECT edition1.id, 'edition' as type, edition1.id as edition, edition1.shortcut as text, 'blue-folders-stack' as icon,
                    (
                        EXISTS( SELECT * FROM editions WHERE path <@ edition1.path AND id <> edition1.id )
                        OR
                        EXISTS( SELECT true FROM ad_places WHERE ad_places.edition = edition1.id  )
                    )
                    as have_childs
                FROM editions as edition1
                WHERE
                    edition1.id <> '00000000-0000-0000-0000-000000000000'
                    AND subpath(edition1.path, nlevel(edition1.path) - 2, 1)::text = replace(?, '-', '')::text
                ORDER BY edition1.shortcut
            ) UNION ALL (
                SELECT id, 'place' as type, edition, title as text, 'zone' as icon, false as have_childs
                FROM ad_places
                WHERE edition=?
                ORDER BY title
            )
        ";

        push @data, $i_node;
        push @data, $i_node;

        my $data = $c->sql->Q("$sql", \@data)->Hashes;

        foreach my $item (@$data) {
            my $record = {
                id      => $item->{id},
                edition => $item->{edition},
                text    => $item->{text},
                leaf    => $item->{have_childs},
                icon    => $item->{icon},
                type    => $item->{type},
            };
            if ( $item->{have_childs} ) {
                $record->{leaf} = $c->json->false;
            } else {
                $record->{leaf} = $c->json->true;
            }
            push @result, $record;
        }
    }

    $success = $c->json->true unless (@errors);

    $c->render_json( \@result );
}

1;
