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
    
    my $edition     = $c->param("edition") || undef;
    my $showArchive = $c->param("showArchive") || "false";
    
    my @params;
    
    my $sql1 = "
        SELECT
            t1.id, t1.issystem, t1.catalog, t2.shortcut as catalog_shortcut,
            t1.title, t1.shortcut, t1.description,
            to_char(t1.begindate, 'YYYY-MM-DD HH24:MI:SS') as begindate,
            to_char(t1.enddate, 'YYYY-MM-DD HH24:MI:SS') as enddate,
            t1.enabled, t1.created, t1.updated,
            EXTRACT( DAY FROM t1.enddate-t1.begindate) as totaldays,
            EXTRACT( DAY FROM now()-t1.begindate) as passeddays
        FROM fascicles t1, catalog t2
        WHERE
            t1.issystem = false AND t1.catalog = t2.id AND t1.enabled = true
    ";
    
    my $sql2 = "
        SELECT
            t1.id, t1.issystem, t1.catalog, t2.shortcut as catalog_shortcut,
            t1.title, t1.shortcut, t1.description,
            to_char(t1.begindate, 'YYYY-MM-DD HH24:MI:SS') as begindate,
            to_char(t1.enddate, 'YYYY-MM-DD HH24:MI:SS') as enddate,
            t1.enabled, t1.created, t1.updated,
            EXTRACT( DAY FROM t1.enddate-t1.begindate) as totaldays,
            EXTRACT( DAY FROM now()-t1.begindate) as passeddays
        FROM fascicles t1, catalog t2
        WHERE
            t1.issystem = false AND t1.catalog = t2.id AND t1.enabled = false
    ";
    
    if ($edition) {
        $sql1 .= " AND catalog =? ";
        push @params, $edition;
    }
    
    if ($showArchive eq 'true') {
        if ($edition) {
            $sql2 .= " AND catalog =? ";
            push @params, $edition;
        }
        $sql1 = " ($sql1) UNION ($sql2) ";
    }
    
    $sql1 .= " ORDER BY enabled desc, catalog_shortcut, begindate ";

    my $result = $c->sql->Q($sql1, \@params)->Hashes;

    $c->render_json( { data => $result } );
}

sub combogroups {
    my $c = shift;
    my $result = $c->sql->Q(" SELECT DISTINCT t2.id, t2.name, t2.shortcut FROM fascicles t1, catalog t2 WHERE t1.catalog = t2.id ORDER BY t2.shortcut ")->Hashes;
    $c->render_json( { data => $result } );
}

sub create {
    my $c = shift;

    my $id = $c->uuid();

    my $i_name        = $c->param("name");
    my $i_path        = $c->param("path");
    my $i_shortcut    = $c->param("shortcut");
    my $i_description = $c->param("description");

    $c->sql->Do("
        INSERT INTO roles(id, catalog, name, shortcut, description, created, updated)
        VALUES (?, ?, ?, ?, ?, now(), now());
    ", [ $id, $i_path, $i_name, $i_shortcut, $i_description ]);

    $c->render_json( { success => $c->json->true} );
}

sub read {

    my $c = shift;

    my $id = $c->param("id");

    my $result = $c->sql->Q("
        SELECT t1.id, t1.name, t1.shortcut, t1.description,
            t2.id as catalog_id, t2.name as catalog_name, t2.shortcut as catalog_shortcut
        FROM roles t1, catalog t2
        WHERE t1.id =? AND t1.catalog = t2.id
        ORDER BY t2.shortcut, t1.shortcut
    ", [ $id ])->Hash;

    $c->render_json( { success => $c->json->true, data => $result } );
}


sub update {
    my $c = shift;

    my $i_id          = $c->param("id");
    my $i_name        = $c->param("name");
    my $i_path        = $c->param("path");
    my $i_shortcut    = $c->param("shortcut");
    my $i_description = $c->param("description");

    $c->sql->Do("
        UPDATE roles
            SET catalog=?, name=?, shortcut=?, description=?, updated=now()
        WHERE id =?;
    ", [ $i_path, $i_name, $i_shortcut, $i_description, $i_id ]);

    $c->render_json( { success => $c->json->true} );
}

sub delete {
    my $c = shift;
    my @ids = $c->param("id");
    foreach my $id (@ids) {
        $c->sql->Do(" DELETE FROM roles WHERE id=? ", [ $id ]);
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
