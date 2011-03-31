package Inprint::Catalog::Editions;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use utf8;
use strict;
use warnings;



use base 'Inprint::BaseController';

sub read {
    my $c = shift;
    my $i_id = $c->param("id");

    my @errors;
    my $success = $c->json->false;

    $c->check_uuid( \@errors, "id", $i_id);

    my $result = [];

    unless (@errors) {
        $result = $c->Q("
            SELECT t1.*,
                subpath(path, -2,1) as parent,
                (select shortcut from editions where subpath(path, -1,1) = subpath(t1.path, -2,1) ) as parent_shortcut
            FROM editions t1 WHERE t1.id = ?
        ", [ $i_id ])->Hash;
    }

    $success = $c->json->true unless (@errors);
    $c->render_json( { success => $success, errors => \@errors, data => $result } );
}

sub tree {

    my $c = shift;

    my $i_node = $c->param("node");
    $i_node = '00000000-0000-0000-0000-000000000000' unless ($i_node);
    $i_node = '00000000-0000-0000-0000-000000000000' if ($i_node eq "root-node");

    my $i_show_briefcase = $c->param("show_briefcase");

    my @errors;
    my $success = $c->json->false;

    $c->check_uuid( \@errors, "id", $i_node);

    my @result;

    unless (@errors) {
        my $sql;
        my @data;

        $sql = "
            SELECT *, ( SELECT count(*) FROM editions c2 WHERE c2.path ~ ('*.' || replace(?, '-', '')::text || '.*{2}')::lquery ) as have_childs
            FROM editions
            WHERE
                id <> '00000000-0000-0000-0000-000000000000'
                AND subpath(path, nlevel(path) - 2, 1)::text = replace(?, '-', '')::text
        ";

        push @data, $i_node;
        push @data, $i_node;

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

sub create {
    my $c = shift;

    my $id            = $c->uuid();

    my $i_path        = $c->param("path");
    my $i_title       = $c->param("title");
    my $i_shortcut    = $c->param("shortcut");
    my $i_description = $c->param("description");

    my @errors;
    my $success = $c->json->false;

    $c->check_path( \@errors, "path", $i_path);
    $c->check_text( \@errors, "title", $i_title);
    $c->check_text( \@errors, "shortcut", $i_shortcut);

    $c->check_access( \@errors, "domain.editions.manage");

    my $parent = $c->check_record(\@errors, "editions", "edition", $i_path);

    unless (@errors) {
        $c->Do("
            INSERT INTO editions (id, title, shortcut, description, path)
                VALUES (?, ?, ?, ?, replace(?, '-',  '')::ltree)
        ", [ $id, $i_title, $i_shortcut, $i_description, $parent->{path} ]);
    }

    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors });
}

sub update {
    my $c = shift;

    my $i_id          = $c->param("id");
    my $i_path        = $c->param("path");
    my $i_title       = $c->param("title");
    my $i_shortcut    = $c->param("shortcut");
    my $i_description = $c->param("description");

    my @errors;
    my $success = $c->json->false;

    $c->check_uuid( \@errors, "id", $i_id);
    $c->check_path( \@errors, "path", $i_path);
    $c->check_text( \@errors, "title", $i_title);
    $c->check_text( \@errors, "shortcut", $i_shortcut);

    $c->check_access( \@errors, "domain.editions.manage");

    push @errors, { id => "id", msg => "Incorrectly filled field"}
        if ($i_id eq "00000000-0000-0000-0000-000000000000");

    my $parent = $c->check_record(\@errors, "editions", "edition", $i_path);

    unless (@errors) {

        $c->Do(" UPDATE editions SET title=?, shortcut=?, description=?, path=replace(?, '-',  '')::ltree WHERE id=? ",
            [ $i_title, $i_shortcut, $i_description, $parent->{path} . ".$i_id", $i_id ]);

        $c->Do(" UPDATE documents SET edition_shortcut=? WHERE edition=? ",
            [ $i_shortcut, $i_id ]);

    }

    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors });
}

sub delete {
    my $c = shift;
    my $i_id = $c->param("id");

    my @errors;
    my $success = $c->json->false;

    $c->check_uuid( \@errors, "id", $i_id);
    $c->check_access( \@errors, "domain.editions.manage");

    push @errors, { id => "id", msg => "Incorrectly filled field"}
        if ($i_id eq "00000000-0000-0000-0000-000000000000");

    unless (@errors) {
        $c->Do(" DELETE FROM editions WHERE id =? ", [ $i_id ]);
    }

    $success = $c->json->true unless (@errors);

    $c->render_json({ success => $success, errors => \@errors });
}

1;
