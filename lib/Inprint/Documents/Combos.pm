package Inprint::Documents::Combos;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use base 'Inprint::BaseController';

sub editions {
    my $c = shift;
    my $result = $c->sql->Q("
        SELECT t1.id, t1.shortcut as title, nlevel(path) as nlevel, '' as description,
            array_to_string( ARRAY( select shortcut FROM catalog where path @> t1.path ORDER BY nlevel(path) ), '.') as title_path
        FROM editions t1
        ORDER BY title_path
    ")->Hashes;
    $c->render_json( { data => $result } );
}


sub stages {
    my $c = shift;

    my $i_edition  = $c->param("flt_edition") || undef;

    my $branchID = $c->sql->Q(" SELECT id FROM branches WHERE edition=?", [ $i_edition ])->Value;
    my $result = [];

    if ($branchID) {
        $result = $c->sql->Q("
            SELECT t1.id, t1.shortcut as title, t2.color
            FROM stages t1, readiness t2
            WHERE branch=? AND t2.id = t1.readiness
            ORDER BY t2.weight, t1.shortcut
        ", [$branchID])->Hashes;
    }

    $c->render_json( { data => $result || [] } );
}


sub assignments {
    my $c = shift;

    my $i_stage = $c->param("flt_stage") || undef;

    my $result = $c->sql->Q("
        SELECT t1.id, t2.type, t2.shortcut as title, t2.description,
            CASE WHEN t2.type='group' THEN 'folders' ELSE 'user' END as icon
        FROM map_principals_to_stages t1, view_principals t2
        WHERE t2.id = t1.principal AND t1.stage=?
        ORDER BY t2.type, t2.shortcut
    ", [ $i_stage ])->Hashes;

    $c->render_json( { data => $result } );
}

sub fascicles {

    my $c = shift;

    my $i_edition  = $c->param("flt_edition") || undef;

    my $sql = "
        SELECT t1.id, t2.shortcut ||'/'|| t1.title as title, t1.description
        FROM fascicles t1, editions t2
        WHERE
            t1.edition = t2.id
            AND t1.issystem = false
            AND t1.enabled = true
            AND t1.edition IN (
                SELECT id FROM editions WHERE path ~ ('*.' || replace(?, '-', '')::text || '.*')::lquery
            )
        ORDER BY t1.enddate DESC, t2.shortcut, t1.title ";

    my $result = $c->sql->Q($sql, [ $i_edition ])->Hashes;

    unshift @$result, {
        id => "99999999-9999-9999-9999-999999999999",
        icon => "bin",
        spacer => $c->json->true,
        bold => $c->json->true,
        title => $c->l("Recycle Bin"),
        description => $c->l("Removed documents")
    };

    unshift @$result, {
        id => "00000000-0000-0000-0000-000000000000",
        icon => "briefcase",
        bold => $c->json->true,
        title => $c->l("Briefcase"),
        description => $c->l("Briefcase for reserved documents")
    };

    $c->render_json( { data => $result } );
}

sub headlines {
    my $c = shift;
    my $i_fascicle = $c->param("flt_fascicle") || undef;
    my $sql = " SELECT DISTINCT headline as id, headline_shortcut as title FROM documents WHERE fascicle = ? ORDER BY headline_shortcut ";
    my $result = $c->sql->Q($sql, [ $i_fascicle ])->Hashes;
    $c->render_json( { data => $result } );
}

sub rubrics {
    my $c = shift;
    my $i_headline = $c->param("flt_headline") || undef;
    my $sql = " SELECT rubric as id, rubric_shortcut as title FROM documents WHERE headline=? ORDER BY rubric_shortcut ";
    my $result = $c->sql->Q($sql, [ $i_headline ])->Hashes;
    $c->render_json( { data => $result } );
}

1;
