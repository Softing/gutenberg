package Inprint::Calendar;

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
            SELECT *, ( SELECT count(*) FROM editions c2 WHERE c2.path ~ ('*.' || replace(?, '-', '')::text || '.*{2}')::lquery ) as have_childs
            FROM editions
            WHERE
                id <> '00000000-0000-0000-0000-000000000000'
                AND subpath(path, nlevel(path) - 2, 1)::text = replace(?, '-', '')::text
        ";
        push @data, $i_node;
        push @data, $i_node;
        
        my $data = $c->sql->Q("$sql ORDER BY shortcut", \@data)->Hashes;
        
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
            push @result, $record;
        }
    }

    $success = $c->json->true unless (@errors);
    
    $c->render_json( \@result );
}

sub list {

    my $c = shift;

    my @params;

    my $edition     = $c->param("edition") || undef;
    my $showArchive = $c->param("showArchive") || "false";

    my $editions = $c->access->GetChildrens("editions.documents.work");
    
    my $sql1 = "
        SELECT
            t1.id, t1.is_system, t1.edition, t2.shortcut as edition_shortcut,
            t1.title, t1.shortcut, t1.description,
            to_char(t1.begindate, 'YYYY-MM-DD HH24:MI:SS') as begindate,
            to_char(t1.enddate, 'YYYY-MM-DD HH24:MI:SS') as enddate,
            t1.is_enabled, t1.created, t1.updated,
            EXTRACT( DAY FROM t1.enddate-t1.begindate) as totaldays,
            EXTRACT( DAY FROM now()-t1.begindate) as passeddays
        FROM fascicles t1, editions t2
        WHERE
            t1.edition = ANY (?)
            AND t1.is_system = false AND t1.edition = t2.id
    ";

    push @params, $editions;

    if ($edition && $edition ne "00000000-0000-0000-0000-000000000000") {
        $sql1 .= " AND edition=? ";
        push @params, $edition;
    }

    if ($showArchive eq 'true') {
        
    } else {
        $sql1 .= " AND t1.is_enabled = true ";
    }

    $sql1 .= " ORDER BY enddate DESC";

    my $result = $c->sql->Q($sql1, \@params)->Hashes;

    $c->render_json( { data => $result } );
}

sub create {
    my $c = shift;

    my $id = $c->uuid();
    my $version = $c->uuid();

    my $i_edition     = $c->param("edition");
    my $i_title       = $c->param("title");
    my $i_shortcut    = $c->param("shortcut");
    my $i_description = $c->param("description");
    
    my $i_begindate   = $c->param("begindate");
    my $i_enddate     = $c->param("enddate");
    
    $c->sql->Do("
        INSERT INTO fascicles (
            id, version, is_system, edition, title, shortcut, description, begindate, enddate,
            is_enabled, created, updated)
            VALUES (?, ?, false, ?, ?, ?, ?, ?, ?, true, now(), now());
    ", [ $id, $version, $i_edition, $i_title, $i_title, $i_title, $i_begindate, $i_enddate ]);

    $c->render_json( { success => $c->json->true} );
}

sub read {

    my $c = shift;

    my $id = $c->param("id");

    my $result = $c->sql->Q("
        SELECT id, is_system, edition, title, shortcut, description, begindate, enddate,
            is_enabled, created, updated
        FROM fascicles
        WHERE id=? ORDER shortcut
    ", [ $id ])->Hash;

    $c->render_json( { success => $c->json->true, data => $result } );
}


sub update {
    my $c = shift;

    my $i_id          = $c->param("id");
    my $i_title       = $c->param("name");
    my $i_edition     = $c->param("edition");
    my $i_shortcut    = $c->param("shortcut");
    my $i_description = $c->param("description");
    
    my $i_begindate   = $c->param("begindate");
    my $i_enddate     = $c->param("enddate");

    $c->sql->Do("
        UPDATE fascicles
            SET title=?, shortcut=?, description=?, begindate=?, enddate=?
        WHERE id =?;
    ", [ $i_title, $i_title, $i_title, $i_begindate, $i_enddate, $i_id ]);

    $c->render_json( { success => $c->json->true} );
}

sub delete {
    my $c = shift;
    my @ids = $c->param("ids");
    foreach my $id (@ids) {
        $c->sql->Do(" DELETE FROM fascicles WHERE id=? ", [ $id ]);
    }
    $c->render_json( { success => $c->json->true } );
}

sub enable {
    my $c = shift;
    my @ids = $c->param("ids");
    foreach my $id (@ids) {
        
        $c->sql->Do(" UPDATE fascicles SET is_enabled = true WHERE id=? ", [ $id ]);
        $c->sql->Do(" UPDATE documents SET isopen = true WHERE fascicle=? ", [ $id ]);
        
    }
    $c->render_json( { success => $c->json->true } );
}

sub disable {
    my $c = shift;
    my @ids = $c->param("ids");
    foreach my $id (@ids) {
        $c->sql->Do(" UPDATE fascicles SET is_enabled = false WHERE id=? ", [ $id ]);
        $c->sql->Do(" UPDATE documents SET isopen = false WHERE fascicle=? ", [ $id ]);
    }
    $c->render_json( { success => $c->json->true } );
}

1;
