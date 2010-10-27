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
    my $dir      = $c->param("dir")          || "DESC";
    my $sort     = $c->param("sort")         || "created";

    # Filters
    my $edition  = $c->param("flt_edition")  || undef;
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

            dcm.workgroup, dcm.workgroup_shortcut,
            dcm.inworkgroups, dcm.copygroup,

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
        $sql_filters .= " AND holder=? ";
        push @params, $c->QuerySessionGet("member.id");
        $sql_filters .= " AND isopen = true ";
        $sql_filters .= " AND fascicle <> '99999999-9999-9999-9999-999999999999' ";
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
        $sql_filters .= " AND ? = ANY(dcm.inworkgroups) ";
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
            if ( $sort ~~ ["title", "maingroup_shortcut", "fascicle_shortcut", "headline_shortcut", "created",
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

    #print STDERR $sql_query;

    # Create result
    $c->render_json( { "data" => $result, "total" => $total } );
}


sub create {
    my $c = shift;

    my $sql;
    my @fields;
    my @data;
    my @errors;

    my $id = $c->uuid();
    my $copyid = $c->uuid();
    my $success = $c->json->false;

    my $i_edition    = $c->param("edition");
    my $i_stage      = $c->param("stage");
    my $i_assignment = $c->param("assignment");

    my $i_enddate    = $c->param("enddate");
    my $i_fascicle   = $c->param("fascicle") || "00000000-0000-0000-0000-000000000000";
    my $i_headline   = $c->param("headline");
    my $i_rubric     = $c->param("rubric");

    my $i_title      = $c->param("title");
    my $i_author     = $c->param("author");
    my $i_size       = $c->param("size");
    my $i_comment    = $c->param("comment");

    push @errors, { id => "title",      msg => "" } unless $i_title;
    push @errors, { id => "enddate",    msg => "" } unless $i_enddate;
    push @errors, { id => "edition",    msg => "" } unless $i_edition;
    push @errors, { id => "fascicle",   msg => "" } unless $i_fascicle;
    push @errors, { id => "assignment", msg => "" } unless $i_assignment;

    unless ( @errors ) {

        push @fields, "id";
        push @data, $id;

        push @fields, "copygroup";
        push @data, $copyid;

        push @fields, "title";
        push @data, $i_title;

        push @fields, "pdate";
        push @data, $i_enddate;

        push @fields, "psize";
        push @data, $i_size || 0;

        push @fields, "isopen";
        push @data, 'true';

        push @fields, "islooked";
        push @data, 'false';

        push @fields, "files";
        push @data, 0;

        push @fields, "images";
        push @data, 0;

        push @fields, "rsize";
        push @data, 0;

        push @fields, "rdate";
        push @data, undef;

        # Set Author
        if ($i_author) {
            push @fields, "author";
            push @data, $i_author;
        }

        #filepath
        my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);

        $year += 1900;
        $mon += 1;

        push @fields, "filepath";
        push @data, "/$year/$mon/$id";

        # Creator
        push @fields, "creator";
        push @fields, "creator_shortcut";
        push @data, $c->QuerySessionGet("member.id");
        push @data, $c->QuerySessionGet("member.shortcut");

        # Set edition
        my $edition = $c->sql->Q(" SELECT id, shortcut FROM editions WHERE id = ?", [ $i_edition ])->Hash;
        if ($edition->{id} && $edition->{shortcut}) {
            push @fields, "edition";
            push @fields, "edition_shortcut";
            push @data, $edition->{id};
            push @data, $edition->{shortcut};

            # Set ineditions[]
            my $editions = $c->sql->Q("
                SELECT ARRAY( select id from editions where path @> ( select path from editions where id = ? ) )
            ", [ $edition->{id} ])->Array;
            push @fields, "ineditions";
            push @data, $editions;

        }

        # Set Assignmnent

        my $assignment = $c->sql->Q("
            SELECT
                id,
                catalog, catalog_shortcut,
                principal_type, principal, principal_shortcut,
                branch, branch_shortcut,
                stage, stage_shortcut,
                readiness, readiness_shortcut, progress, color
            FROM view_assignments WHERE id=?
        ", [ $i_assignment ])->Hash;

        if ($assignment->{id}) {

            # Set Workgroup
            push @fields, "workgroup";
            push @fields, "workgroup_shortcut";
            push @data, $assignment->{catalog};
            push @data, $assignment->{catalog_shortcut};

            # Set Inworkgroups[]
            my $catalogs = $c->sql->Q("
                SELECT ARRAY( select id from catalog where path @> ( select path from catalog where id = ? ) )
            ", [ $assignment->{catalog} ])->Array;
            push @fields, "inworkgroups";
            push @data, $catalogs;

            # Set Branch
            push @fields, "branch";
            push @fields, "branch_shortcut";
            push @data, $assignment->{branch};
            push @data, $assignment->{branch_shortcut};

            # Set Stage
            push @fields, "stage";
            push @fields, "stage_shortcut";
            push @data, $assignment->{stage};
            push @data, $assignment->{stage_shortcut};

            # Set Readiness
            push @fields, "readiness";
            push @fields, "readiness_shortcut";
            push @data, $assignment->{readiness};
            push @data, $assignment->{readiness_shortcut};

            # Set Color
            push @fields, "color";
            push @data, $assignment->{color};

            # Set Progress
            push @fields, "progress";
            push @data, $assignment->{progress};

            # Set Holder
            push @fields, "holder";
            push @fields, "holder_shortcut";
            push @data, $assignment->{principal};
            push @data, $assignment->{principal_shortcut};

            # Set manager
            push @fields, "manager";
            push @fields, "manager_shortcut";
            push @data, $assignment->{principal};
            push @data, $assignment->{principal_shortcut};

        }

        # Fascicle, && Headline && Rubric
        my $fascicle = $c->sql->Q(" SELECT id, shortcut FROM fascicles WHERE id = ?", [ $i_fascicle ])->Hash;
        if ($fascicle->{id} && $fascicle->{shortcut}) {

            push @fields, "fascicle";
            push @fields, "fascicle_shortcut";
            push @data, $fascicle->{id};
            push @data, $fascicle->{shortcut};

            if ($i_headline) {

                my $headline = $c->sql->Q(" SELECT id, shortcut FROM tags WHERE id = ?", [ $i_headline ])->Hash;

                if ($headline->{id} && $headline->{shortcut}) {
                    push @fields, "headline";
                    push @fields, "headline_shortcut";
                    push @data, $headline->{id};
                    push @data, $headline->{shortcut};
                }
                if ($i_rubric) {
                    my $rubric = $c->sql->Q(" SELECT id, shortcut FROM tags WHERE id = ?", [ $i_rubric ])->Hash;
                    if ($rubric->{id} && $rubric->{shortcut}) {
                        push @fields, "rubric";
                        push @fields, "rubric_shortcut";
                        push @data, $rubric->{id};
                        push @data, $rubric->{shortcut};
                    }
                }
            }

        }

        my @placeholders;
        foreach (@data) { push @placeholders, "?"; }

        $sql = " INSERT INTO documents (" . ( join ",", @fields ) .") VALUES (". ( join ",", @placeholders ) .") ";
        $c->sql->Do($sql, \@data);

        $success = $c->json->true;
    }

    $c->render_json( { success => $success, errors => \@errors } );
}

sub read {

    my $c = shift;

    my $id = $c->param("id");

    my $result = $c->sql->Q("
        SELECT
            dcm.id,
            dcm.edition, dcm.edition_shortcut,
            dcm.fascicle, dcm.fascicle_shortcut,
            dcm.headline, dcm.headline_shortcut,
            dcm.rubric, dcm.rubric_shortcut,
            dcm.workgroup, dcm.workgroup_shortcut,
            dcm.inworkgroups, dcm.copygroup,
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
        FROM documents dcm WHERE dcm.id=?
    ", [ $id ])->Hash;

    $c->render_json( { success => $c->json->true, data => $result } );
}


sub update {
    my $c = shift;

    my $i_id      = $c->param("id");
    my $i_title   = $c->param("title");
    my $i_author  = $c->param("author");
    my $i_size    = $c->param("size") || 0;
    my $i_enddate = $c->param("enddate");

    $c->sql->Do("
        UPDATE documents
            SET title=?, author=?, psize=?, pdate=?
        WHERE id=?;
    ", [ $i_title, $i_author, $i_size, $i_enddate, $i_id ]);

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

sub capture {
    my $c = shift;
    my @ids = $c->param("id");

    my $success = $c->json->false;

    my $assignment = $c->sql->Q("
        SELECT
            id,
            catalog, catalog_shortcut,
            principal_type, principal, principal_shortcut,
            branch, branch_shortcut,
            stage, stage_shortcut,
            readiness, readiness_shortcut,
            progress, color
        FROM view_assignments
        WHERE id = (
            SELECT option_value
            FROM options
            WHERE option_name = 'transfer.capture.destination' AND member=?
        )::uuid
    ", [ $c->QuerySessionGet("member.id") ])->Hash;

    if ($assignment) {
        $success = $c->json->true;
        foreach my $id (@ids) {

            my $workgroups = $c->sql->Q("
                SELECT ARRAY( select id from catalog where path @> ( select path from catalog where id = ? ) )
            ", [ $assignment->{catalog} ])->Array;

            $c->sql->Do("
                UPDATE documents SET
                    holder=?, holder_shortcut=?,
                    workgroup=?, workgroup_shortcut=?, inworkgroups=?,
                    readiness=?, readiness_shortcut=?, color=?, progress=?, rdate=now()
                WHERE id=?
            ", [
                $assignment->{principal}, $assignment->{principal_shortcut},
                $assignment->{catalog}, $assignment->{catalog_shortcut}, $workgroups,
                $assignment->{readiness}, $assignment->{readiness_shortcut},
                $assignment->{color}, $assignment->{progress},
                $id
            ]);
        }
    }

    $c->render_json( { success => $success } );
}

sub transfer {
    my $c = shift;

    my @ids = $c->param("id");
    my $tid = $c->param("transfer");

    my $success = $c->json->false;

    my $assignment = $c->sql->Q("
        SELECT
            id,
            catalog, catalog_shortcut,
            principal_type, principal, principal_shortcut,
            branch, branch_shortcut,
            stage, stage_shortcut,
            readiness, readiness_shortcut,
            progress, color
        FROM view_assignments
        WHERE id = ?
    ", [ $tid ])->Hash;

    if ($assignment) {
        $success = $c->json->true;
        foreach my $id (@ids) {

            my $workgroups = $c->sql->Q("
                SELECT ARRAY( select id from catalog where path @> ( select path from catalog where id = ? ) )
            ", [ $assignment->{catalog} ])->Array;

            $c->sql->Do("
                UPDATE documents SET
                    holder=?, holder_shortcut=?,
                    workgroup=?, workgroup_shortcut=?, inworkgroups=?,
                    readiness=?, readiness_shortcut=?, color=?, progress=?, rdate=now()
                WHERE id=?
            ", [
                $assignment->{principal}, $assignment->{principal_shortcut},
                $assignment->{catalog}, $assignment->{catalog_shortcut}, $workgroups,
                $assignment->{readiness}, $assignment->{readiness_shortcut},
                $assignment->{color}, $assignment->{progress},
                $id
            ]);
        }
    }

    $c->render_json( { success => $success } );
}

sub briefcase {
    my $c = shift;

    my @ids = $c->param("id");

    my $success = $c->json->false;

    my $fascicle = $c->sql->Q(" SELECT id, shortcut FROM fascicles WHERE id='00000000-0000-0000-0000-000000000000' ")->Hash;

    if ($fascicle) {
        $success = $c->json->true;
        foreach my $id (@ids) {

            #my $tags     = $c->sql->Q(" SELECT headline, headline_shortcut, rubric, rubric_shortcut FROM documents WHERE id=? ", [ $id ])->Hash;
            #my $headline = $c->sql->Q(" SELECT * FROM headlines WHERE tag=? ", [ $tags->{headline} ])->Hash;
            #my $rubric   = $c->sql->Q(" SELECT * FROM rubrics   WHERE tag=? ", [ $tags->{rubric} ])->Hash;

            $c->sql->Do(" UPDATE documents SET fascicle=?, fascicle_shortcut=? WHERE id=? ", [ $fascicle->{id}, $fascicle->{shortcut}, $id ]);
        }
    }

    $c->render_json( { success => $success } );
}

sub recycle {
    my $c = shift;
    my @ids = $c->param("id");
    foreach my $id (@ids) {
        #$c->sql->Do(" DELETE FROM roles WHERE id=? ", [ $id ]);
    }
    $c->render_json( { success => $c->json->true } );
}


1;
