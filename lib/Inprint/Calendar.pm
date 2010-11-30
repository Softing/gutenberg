package Inprint::Calendar;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use base 'Inprint::BaseController';

sub list {

    my $c = shift;

    my @params;

    my $edition     = $c->param("edition") || undef;
    my $showArchive = $c->param("showArchive") || "false";

    my $editions = $c->access->GetChildrens("editions.documents.work");
    
    my $sql1 = "
        SELECT
            t1.id, t1.issystem, t1.edition, t2.shortcut as edition_shortcut,
            t1.title, t1.shortcut, t1.description,
            to_char(t1.begindate, 'YYYY-MM-DD HH24:MI:SS') as begindate,
            to_char(t1.enddate, 'YYYY-MM-DD HH24:MI:SS') as enddate,
            t1.enabled, t1.created, t1.updated,
            EXTRACT( DAY FROM t1.enddate-t1.begindate) as totaldays,
            EXTRACT( DAY FROM now()-t1.begindate) as passeddays
        FROM fascicles t1, editions t2
        WHERE
            t1.edition = ANY (?)
            AND t1.issystem = false AND t1.edition = t2.id
    ";

    push @params, $editions;

    if ($edition && $edition ne "00000000-0000-0000-0000-000000000000") {
        $sql1 .= " AND edition=? ";
        push @params, $edition;
    }

    if ($showArchive eq 'true') {
        
    } else {
        $sql1 .= " AND t1.enabled = true ";
    }

    $sql1 .= " ORDER BY enddate DESC";

    my $result = $c->sql->Q($sql1, \@params)->Hashes;

    $c->render_json( { data => $result } );
}

sub create {
    my $c = shift;

    my $id = $c->uuid();

    my $i_edition     = $c->param("edition");
    my $i_title       = $c->param("title");
    my $i_shortcut    = $c->param("shortcut");
    my $i_description = $c->param("description");
    
    my $i_begindate   = $c->param("begindate");
    my $i_enddate     = $c->param("enddate");
    
    $c->sql->Do("
        INSERT INTO fascicles (
            id, issystem, edition, title, shortcut, description, begindate, enddate,
            enabled, created, updated)
            VALUES (?, false, ?, ?, ?, ?, ?, ?, true, now(), now());
    ", [ $id, $i_edition, $i_title, $i_title, $i_title, $i_begindate, $i_enddate ]);

    $c->render_json( { success => $c->json->true} );
}

sub read {

    my $c = shift;

    my $id = $c->param("id");

    my $result = $c->sql->Q("
        SELECT id, issystem, edition, title, shortcut, description, begindate, enddate,
            enabled, created, updated
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
    my @ids = $c->param("id");
    foreach my $id (@ids) {
        $c->sql->Do(" DELETE FROM fascicles WHERE id=? ", [ $id ]);
    }
    $c->render_json( { success => $c->json->true } );
}


sub map {
    my $c = shift;

    my $i_id          = $c->param("id");
    my @i_rules       = $c->param("rules");
    my $i_recursive   = $c->param("recursive");

    $c->sql->Do(" DELETE FROM map_role_to_rule WHERE role=? ", [ $i_id ]);

    foreach my $string (@i_rules) {
        my ($rule, $mode) = split "::", $string;
        $c->sql->Do("
            INSERT INTO map_role_to_rule(role, rule, mode)
                VALUES (?, ?, ?);
        ", [$i_id, $rule, $mode]);
    }

    $c->render_json( { success => $c->json->true } );
}

sub mapping {

    my $c = shift;

    my $id = $c->param("id");

    my $data = $c->sql->Q("
        SELECT role, rule, mode FROM map_role_to_rule WHERE role =?
    ", [ $id ])->Hashes;

    my $result = {};

    foreach my $item (@$data) {
        $result->{ $item->{rule} } = $item->{mode};
    }

    $c->render_json( { data => $result } );
}

1;
