package Inprint::Documents::Combos;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use base 'Inprint::BaseController';

sub groups {
    my $c = shift;

    my $result = $c->sql->Q("
        SELECT t1.id, t1.shortcut as title, nlevel(path) as nlevel, '' as description,
            array_to_string( ARRAY( select shortcut FROM catalog where path @> t1.path ), '.') as title_path
        FROM catalog t1
        ORDER BY title_path
    ")->Hashes;

    #my $oftenused = $c->sql->Q("
    #    SELECT id, shortcut as title, nlevel(path) as nlevel, description
    #    FROM catalog WHERE nlevel(path) = 2 ORDER BY path
    #")->Hashes;
    #
    #foreach my $item (@$oftenused) {
    #    unshift @$result, $item;
    #}

    $c->render_json( { data => $result } );
}

sub fascicles {

    my $c = shift;

    my @data;
    my $cgi_group    = $c->param("flt_group")    || undef;

    my $sql = "
        SELECT t1.id, t2.shortcut ||'/'|| t1.title as title, t1.description
        FROM fascicles t1, catalog t2
        WHERE t1.catalog = t2.id AND t1.issystem = false
    ";

    if ($cgi_group) {
        $sql .= " AND t1.catalog IN (
            SELECT id FROM catalog WHERE path ~ ('*.' || replace(?, '-', '')::text || '.*')::lquery
        ) ";
        push @data, $cgi_group;
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
        id => "",
        icon => "arrow-return-180-left",
        spacer => $c->json->true,
        bold => $c->json->true,
        title => $c->l("All fascicles"),
        description => "Select all fascicles"
    };

    $c->render_json( { data => $result } );
}

sub headlines {

    my $c = shift;

    my @data;

    my $cgi_fascicle = $c->param("flt_fascicle") || undef;

    my $sql = "
        SELECT id, shortcut as title, description FROM headlines WHERE 1=1
    ";

    if ($cgi_fascicle) {
        $sql .= " AND fascicle = ? ";
        push @data, $cgi_fascicle;
    }

    $sql .= " ORDER BY shortcut ";

    my $result = $c->sql->Q($sql, \@data)->Hashes;

    unshift @$result, {
        id => "",
        icon => "arrow-return-180-left",
        spacer => $c->json->true,
        bold => $c->json->true,
        title => $c->l("All headlines"),
        description => "Select all headlines"
    };

    $c->render_json( { data => $result } );
}

sub rubrics {

    my $c = shift;

    my @data;

    my $cgi_fascicle = $c->param("flt_fascicle") || undef;
    my $cgi_headline = $c->param("flt_headline") || undef;

    my $sql = "
        SELECT id, shortcut as title, description FROM rubrics WHERE 1=1
    ";

    if ($cgi_fascicle) {
        $sql .= " AND fascicle = ? ";
        push @data, $cgi_fascicle;
    }

    if ($cgi_headline) {
        $sql .= " AND parent = ? ";
        push @data, $cgi_headline;
    }

    $sql .= " ORDER BY shortcut ";

    my $result = $c->sql->Q($sql, \@data)->Hashes;

    unshift @$result, {
        id => "",
        icon => "arrow-return-180-left",
        spacer => $c->json->true,
        bold => $c->json->true,
        title => $c->l("All rubrics"),
        description => "Select all rubrics"
    };

    $c->render_json( { data => $result } );
}

sub holders {

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
        id => "",
        icon => "arrow-return-180-left",
        spacer => $c->json->true,
        bold => $c->json->true,
        title => $c->l("All holders"),
        description => "Select all holders"
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
        id => "",
        icon => "arrow-return-180-left",
        spacer => $c->json->true,
        bold => $c->json->true,
        title => $c->l("All managers"),
        description => "Select all managers"
    };

    $c->render_json( { data => $result } );
}

sub progress {

    my $c = shift;

    my @data;
    my $cgi_group    = $c->param("flt_group")    || undef;

    my $sql = "
        SELECT t1.id, t1.rule, t1.name, t1.shortcut, t2.name as groupby
        FROM rules t1
            LEFT JOIN rules t2 ON t1.group = t2.rule
        WHERE t1.group is not null
    ";

    if ($cgi_group) {
        $sql .= " AND t1.catalog IN (
            SELECT id FROM catalog WHERE path ~ ('*.' || replace(?, '-', '')::text || '.*')::lquery
        ) ";
        push @data, $cgi_group;
    }

    $sql .= " ORDER BY t2.sortorder, t1.shortcut, t1.name ";

    my $result = $c->sql->Q($sql, \@data)->Hashes;

    $c->render_json( { data => $result } );
}

1;
