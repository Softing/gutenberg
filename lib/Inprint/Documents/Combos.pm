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

sub groups {
    my $c = shift;

    my $result = $c->sql->Q("
        SELECT t1.id, t1.shortcut as title, nlevel(path) as nlevel, '' as description,
            array_to_string( ARRAY( select shortcut FROM catalog where path @> t1.path ORDER BY nlevel(path) ), '.') as title_path
        FROM catalog t1
        ORDER BY title_path
    ")->Hashes;

    $c->render_json( { data => $result } );
}

sub fascicles {

    my $c = shift;

    my @data;
    my $cgi_edition  = $c->param("flt_edition") || undef;
    my $cgi_gridmode = $c->param("gridmode")    || undef;

    my $sql = "
        SELECT t1.id, t2.shortcut ||'/'|| t1.title as title, t1.description
        FROM fascicles t1, editions t2
        WHERE t1.edition = t2.id AND t1.issystem = false
    ";

    if ($cgi_edition) {
        $sql .= " AND t1.edition IN (
            SELECT id FROM editions WHERE path ~ ('*.' || replace(?, '-', '')::text || '.*')::lquery
        ) ";
        push @data, $cgi_edition;
    }

    if ($cgi_gridmode eq "archive")  {
        $sql .= " AND t1.enabled = false ";
    } else {
        $sql .= " AND t1.enabled = true ";
    }

    $sql .= " ORDER BY t1.enddate DESC, t2.shortcut, t1.title ";

    my $result = $c->sql->Q($sql, \@data)->Hashes;

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

    unshift @$result, {
        id => "clear",
        icon => "arrow-return-180-left",
        spacer => $c->json->true,
        bold => $c->json->true,
        title => $c->l("Any fascicles"),
        description => "Select all fascicles"
    };

    $c->render_json( { data => $result } );
}

sub headlines {

    my $c = shift;

    my @data;

    my $cgi_fascicle = $c->param("flt_fascicle") || undef;

    #my $sql = " SELECT id, shortcut as title, description FROM headlines WHERE 1=1 ";
    my $sql = " SELECT headline as id, headline_shortcut as title FROM documents WHERE 1=1 ";

    if ($cgi_fascicle) {
        $sql .= " AND fascicle = ? ";
        push @data, $cgi_fascicle;
    }

    $sql .= " ORDER BY headline_shortcut ";

    my $result = $c->sql->Q($sql, \@data)->Hashes;

    unshift @$result, {
        id => "clear",
        icon => "arrow-return-180-left",
        spacer => $c->json->true,
        bold => $c->json->true,
        title => $c->l("Any headlines"),
        description => "Select all headlines"
    };

    $c->render_json( { data => $result } );
}

sub rubrics {

    my $c = shift;

    my @data;

    my $cgi_fascicle = $c->param("flt_fascicle") || undef;
    my $cgi_headline = $c->param("flt_headline") || undef;

    #my $sql = " SELECT id, shortcut as title, description FROM rubrics WHERE 1=1 ";
    my $sql = " SELECT rubric as id, rubric_shortcut as title FROM documents WHERE 1=1 ";

    if ($cgi_fascicle) {
        $sql .= " AND fascicle = ? ";
        push @data, $cgi_fascicle;
    }

    if ($cgi_headline) {
        $sql .= " AND headline = ? ";
        push @data, $cgi_headline;
    }

    $sql .= " ORDER BY rubric_shortcut ";

    my $result = $c->sql->Q($sql, \@data)->Hashes;

    unshift @$result, {
        id => "clear",
        icon => "arrow-return-180-left",
        spacer => $c->json->true,
        bold => $c->json->true,
        title => $c->l("Any rubrics"),
        description => "Select all rubrics"
    };

    $c->render_json( { data => $result } );
}

sub managers {

    my $c = shift;

    my @data;
    my $cgi_group    = $c->param("flt_group")    || undef;

    my $sql = "
        SELECT id, shortcut as title, position as description
        FROM view_members WHERE 1=1
    ";

    if ($cgi_group) {
        $sql .= "
            AND catalog <@
            ARRAY(SELECT id FROM catalog WHERE path ~ ('*.' || replace(?, '-', '')::text || '.*')::lquery)
        ";
        push @data, $cgi_group;
    }

    $sql .= " ORDER BY title ";

    my $result = $c->sql->Q($sql, \@data)->Hashes;

    unshift @$result, {
        id => "clear",
        icon => "arrow-return-180-left",
        spacer => $c->json->true,
        bold => $c->json->true,
        title => $c->l("Any managers"),
        description => "Select all managers"
    };

    $c->render_json( { data => $result } );
}


sub holders {

    my $c = shift;

    my @data;
    my $cgi_query = $c->param("query")     || undef;
    my $cgi_group = $c->param("flt_group") || undef;

    my $sql = "
        SELECT id, shortcut as title, position as description
        FROM view_members WHERE 1=1
    ";

    if ($cgi_query) {
        $sql .= " AND ( shortcut ILIKE ? OR position ILIKE ?) ";
        push @data, "%$cgi_query%";
        push @data, "%$cgi_query%";
    }

    if ($cgi_group) {
        $sql .= " AND catalog <@ ARRAY(SELECT id FROM catalog WHERE path ~ ('*.' || replace(?, '-', '')::text || '.*')::lquery) ";
        push @data, $cgi_group;
    }

    $sql .= " ORDER BY title ";

    my $result = $c->sql->Q($sql, \@data)->Hashes;

    unshift @$result, {
        id => "clear",
        icon => "arrow-return-180-left",
        spacer => $c->json->true,
        bold => $c->json->true,
        title => $c->l("Any holders"),
        description => "Select all holders"
    };

    $c->render_json( { data => $result } );
}


sub progress {

    my $c = shift;

    my $sql = "
        SELECT t1.id, t1.shortcut as title, t1.description, t1.color
        FROM readiness t1 ORDER BY t1.weight, t1.shortcut
    ";

    my $result = $c->sql->Q($sql)->Hashes;

    unshift @$result, {
        id => "clear",
        icon => "arrow-return-180-left",
        spacer => $c->json->true,
        bold => $c->json->true,
        title => $c->l("Clear selection"),
        description => "Select all readiness"
    };

    $c->render_json( { data => $result } );
}

1;
