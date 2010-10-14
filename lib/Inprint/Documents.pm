package Inprint::Documents;

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

    # Pagination
    my $start    = $c->param("start")        || 0;
    my $limit    = $c->param("limit")        || 60;

    # Grid mode
    my $mode     = $c->param("gridmode")     || "all";

    # Sorting
    my $dir      = $c->param("dir")          || undef;
    my $sort     = $c->param("sort")         || undef;

    # Filters
    my $edition  = $c->param("flt_edition")    || undef;
    my $group    = $c->param("flt_group")    || undef;
    my $title    = $c->param("flt_title")    || undef;
    my $fascicle = $c->param("flt_fascicle") || undef;
    my $headline = $c->param("flt_headline") || undef;
    my $rubric   = $c->param("flt_rubric")   || undef;
    my $manager  = $c->param("flt_manager")  || undef;
    my $holder   = $c->param("flt_holder")   || undef;
    my $progress = $c->param("flt_progress") || undef;

    # Query headers
    my $sql_query = "
        SELECT
            dcm.id,

            dcm.edition, dcm.edition_shortcut,
            dcm.fascicle, dcm.fascicle_shortcut,
            dcm.headline, dcm.headline_shortcut,
            dcm.rubric, dcm.rubric_shortcut,

            dcm.maingroup, dcm.maingroup_shortcut,
            dcm.ingroups, dcm.copygroup,

            dcm.holder,  dcm.holder_shortcut,
            dcm.creator, dcm.creator_shortcut,
            dcm.manager, dcm.manager_shortcut,

            dcm.islooked, dcm.isopen,
            dcm.branch, dcm.branch_shortcut,
            dcm.stage, stage_shortcut,
            dcm.color, dcm.progress,
            dcm.title, dcm.author,
            to_char(dcm.pdate, 'YYYY-MM-DD HH24:MI:SS') as pdate,
            to_char(dcm.rdate, 'YYYY-MM-DD HH24:MI:SS') as rdate,
            dcm.psize, dcm.rsize,
            dcm.images, dcm.files,
            to_char(dcm.created, 'YYYY-MM-DD HH24:MI:SS') as created,
            to_char(dcm.updated, 'YYYY-MM-DD HH24:MI:SS') as updated

        FROM documents dcm

    ";

    my $sql_total = "
        SELECT count(*)
        FROM documents dcm
    ";

    # Set filters
    my $sql_filters = " WHERE 1=1 ";

    # Set mode

    if ($mode eq "todo") {
        $sql_filters .= " AND isopen = true ";
        $sql_filters .= " AND fascicle <> '99999999-9999-9999-9999-999999999999' ";
        $sql_filters .= " AND fascicle <> '00000000-0000-0000-0000-000000000000' ";
    }

    if ($mode eq "all") {
        $sql_filters .= " AND isopen = true ";
        $sql_filters .= " AND fascicle <> '99999999-9999-9999-9999-999999999999' ";
        $sql_filters .= " AND fascicle <> '00000000-0000-0000-0000-000000000000' ";
    }

    if ($mode eq "archive") {
        $sql_filters .= " AND isopen = false ";
        $sql_filters .= " AND fascicle <> '99999999-9999-9999-9999-999999999999' ";
        $sql_filters .= " AND fascicle <> '00000000-0000-0000-0000-000000000000' ";
    }

    if ($mode eq "briefcase") {
        $sql_filters .= " AND fascicle = '00000000-0000-0000-0000-000000000000' ";
    }

    if ($mode eq "recycle") {
        $sql_filters .= " AND fascicle = '99999999-9999-9999-9999-999999999999' ";
    }

    # Set Filters

    if ($title) {
        $sql_filters .= " AND title LIKE ? ";
        push @params, "%$title%";
    }

    if ($edition && $edition ne "clear") {
        $sql_filters .= " AND ? = ANY(dcm.ineditions) ";
        push @params, $edition;
    }

    if ($group && $group ne "clear") {
        $sql_filters .= " AND ? = ANY(dcm.ingroups) ";
        push @params, $group;
    }

    if ($fascicle && $fascicle ne "clear") {
        $sql_filters .= " AND fascicle = ? ";
        push @params, $fascicle;
    }

    if ($headline && $headline ne "clear") {
        $sql_filters .= " AND headline = ? ";
        push @params, $headline;
    }

    if ($rubric && $rubric ne "clear") {
        $sql_filters .= " AND rubric = ? ";
        push @params, $rubric;
    }

    if ($manager && $manager ne "clear") {
        $sql_filters .= " AND manager=? ";
        push @params, $manager;
    }

    if ($holder && $holder ne "clear") {
        $sql_filters .= " AND holder=? ";
        push @params, $holder;
    }

    if ($progress && $progress ne "clear") {
        $sql_filters .= " AND readiness=? ";
        push @params, $progress;
    }

    $sql_total .= $sql_filters;
    $sql_query .= $sql_filters;

    # Calculate total param
    my $total = $c->sql->Q($sql_total, \@params)->Value || 0;

    if ($dir && $sort) {
        if ( $dir ~~ ["ASC", "DESC"] ) {
            if ( $sort ~~ ["title", "maingroup_shortcut", "fascicle_shortcut", "headline_shortcut",
                           "rubric_shortcut", "pages", "manager_shortcut", "progress", "holder_shortcut", "images", "rsize" ] ) {
                $sql_query .= " ORDER BY $sort $dir ";
            }
        }
    }

    # Select rows with pagination
    $sql_query .= " LIMIT ? OFFSET ? ";
    push @params, $limit;
    push @params, $start;
    my $result = $c->sql->Q($sql_query, \@params)->Hashes;

    print STDERR $sql_query;

    # Create result
    $c->render_json( { "data" => $result, "total" => $total } );
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



1;
