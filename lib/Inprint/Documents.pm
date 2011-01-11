package Inprint::Documents;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use File::Copy::Recursive qw(fcopy rcopy dircopy fmove rmove dirmove);

use Inprint::Utils;
use Inprint::Utils::Documents;
use Inprint::Utils::Files;
use Inprint::Utils::Headlines;
use Inprint::Utils::Rubrics;

use base 'Inprint::BaseController';

sub read {

    my $c = shift;

    my $i_id = $c->param("id");

    my @errors;
    my $success = $c->json->false;

    push @errors, { id => "id", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_id));

    my $document;
    unless (@errors) {
        $document = $c->sql->Q("
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
                to_char(dcm.fdate, 'YYYY-MM-DD HH24:MI:SS') as fdate,
                to_char(dcm.ldate, 'YYYY-MM-DD HH24:MI:SS') as ldate,
                dcm.psize, dcm.rsize,
                dcm.images, dcm.files,
                to_char(dcm.created, 'YYYY-MM-DD HH24:MI:SS') as created,
                to_char(dcm.updated, 'YYYY-MM-DD HH24:MI:SS') as updated
            FROM documents dcm WHERE dcm.id=?
        ", [ $i_id ])->Hash;


        $document->{access} = {};
        my $current_member = $c->QuerySessionGet("member.id");

        my @rules = qw(
            documents.update documents.capture documents.move documents.transfer
            documents.briefcase documents.delete documents.recover documents.discuss
            files.add files.delete files.work
        );
        foreach (@rules) {
            if ($document->{holder} eq $current_member) {
                if ($c->access->Check(["catalog.$_:member"], $document->{workgroup})) {
                    $document->{access}->{$_} = $c->json->true;
                }
            }
            if ($document->{holder} ne $current_member) {
                if ($c->access->Check("catalog.$_:group", $document->{workgroup})) {
                    $document->{access}->{$_} = $c->json->true;
                }
            }

            if ($_ eq 'documents.capture' && $document->{holder} eq $current_member) {
                $document->{access}->{$_} = $c->json->false;
            }

            if ($_ eq 'documents.briefcase' && $document->{fascicle} eq '00000000-0000-0000-0000-000000000000') {
                $document->{access}->{$_} = $c->json->false;
            }
        }

    }

    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors, data => $document || {} });
}

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

    my $current_member = $c->QuerySessionGet("member.id");

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
            dcm.pages,
            to_char(dcm.pdate, 'YYYY-MM-DD HH24:MI:SS') as pdate,
            to_char(dcm.fdate, 'YYYY-MM-DD HH24:MI:SS') as fdate,
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

    my $sql_filters = " WHERE 1=1 ";

    #$sql_filters .= " AND id = '296f7e02-9728-46a4-9dc1-b38f8d9e1335' ";

    # Set Restrictions

    $sql_filters .= " AND ( ";
    my $editions = $c->access->GetChildrens("editions.documents.work");
    my $departments = $c->access->GetChildrens("catalog.documents.view:*");

    $sql_filters .= " ( ";
    $sql_filters .= "    dcm.edition = ANY(?) ";
    $sql_filters .= "    AND dcm.workgroup = ANY(?) ";
    $sql_filters .= " ) ";
    push @params, $editions;
    push @params, $departments;
    $sql_filters .= " OR manager=? ";
    push @params, $current_member;
    $sql_filters .= " OR holder=? ";
    push @params, $current_member;
    $sql_filters .= " ) ";

    # Set Filters

    if ($mode eq "todo") {

        my @holders;
        $sql_filters .= " AND holder = ANY(?) ";

        my $departments = $c->sql->Q(" SELECT catalog FROM map_member_to_catalog WHERE member =? ", [ $current_member ])->Values;

        foreach (@$departments) {
            push @holders, $_;
        }

        push @holders, $current_member;
        push @params, \@holders;

        $sql_filters .= " AND isopen = true ";
        $sql_filters .= " AND fascicle <> '99999999-9999-9999-9999-999999999999' ";
    }

    if ($mode eq "all") {
        $sql_filters .= " AND isopen is true ";
        $sql_filters .= " AND fascicle <> '99999999-9999-9999-9999-999999999999' ";
        if ($fascicle && $fascicle ne 'clear' && $fascicle ne '00000000-0000-0000-0000-000000000000') {
            $sql_filters .= " AND fascicle <> '00000000-0000-0000-0000-000000000000' ";
        }
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
        $sql_filters .= " AND headline_shortcut = ? ";
        push @params, $headline;
    }

    if ($rubric && $rubric ne "clear") {
        $sql_filters .= " AND rubric_shortcut = ? ";
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
    if ($limit > 0 && $start >= 0) {
        $sql_query .= " LIMIT ? OFFSET ? ";
        push @params, $limit;
        push @params, $start;
    }

    #die $sql_query;

    my $result = $c->sql->Q($sql_query, \@params)->Hashes;

    foreach my $document (@$result) {

        $document->{pages} = Inprint::Utils::CollapsePagesToString($document->{pages});

        my $copy_count = $c->sql->Q(" SELECT count(*) FROM documents WHERE copygroup=? ", [ $document->{copygroup} ])->Value;
        if ($copy_count > 1) {
            $document->{title} = $document->{title} . " ($copy_count)";
        }

        $document->{access} = {};
        my @rules = qw(update capture move transfer briefcase delete recover);

        foreach (@rules) {
            if ($document->{holder} eq $current_member) {
                if ($c->access->Check(["catalog.documents.$_:*"], $document->{workgroup})) {
                    $document->{access}->{$_} = $c->json->true;
                }
            }
            if ($document->{holder} ne $current_member) {
                if ($c->access->Check("catalog.documents.$_:group", $document->{workgroup})) {
                    $document->{access}->{$_} = $c->json->true;
                }
            }
        }
    }

    # Create result
    $c->render_json( { "data" => $result, "total" => $total } );
}

sub create {
    my $c = shift;

    my $sql;
    my @fields;
    my @data;

    my @errors;
    my $success = $c->json->false;

    my $id      = $c->uuid();
    my $copyid  = $id;

    my $current_member = $c->QuerySessionGet("member.id");

    my $i_edition    = $c->param("edition");
    my $i_workgroup  = $c->param("workgroup");
    my $i_manager    = $c->param("manager");

    my $i_enddate    = $c->param("enddate");
    my $i_fascicle   = $c->param("fascicle") || "00000000-0000-0000-0000-000000000000";
    my $i_headline   = $c->param("headline");
    my $i_rubric     = $c->param("rubric");

    my $i_title      = $c->param("title");
    my $i_author     = $c->param("author");
    my $i_size       = $c->param("size");
    my $i_comment    = $c->param("comment");

    my $manager;
    if ($i_manager) {
        $manager = $i_manager;
    } else {
        $manager = $current_member;
    }

    push @errors, { id => "title", msg => "Incorrectly filled field"}
        unless ($c->is_text($i_title));

    push @errors, { id => "enddate", msg => "Incorrectly filled field"}
        unless ($c->is_date($i_enddate));

    push @errors, { id => "edition", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_edition));

    push @errors, { id => "workgroup", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_workgroup));

    push @errors, { id => "manager", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($manager));

    push @errors, { id => "fascicle", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_fascicle));

    if ($i_fascicle && $i_fascicle ne  "00000000-0000-0000-0000-000000000000") {
        $i_edition = $c->sql->Q(" SELECT edition FROM fascicles WHERE id = ?", [ $i_fascicle ])->Value;
        push @errors, { id => "edition", msg => "Incorrectly filled field"}
            unless ($c->is_uuid($i_edition));
    }

    # Check user access to this function
    unless ( @errors ) {

        if ( $i_workgroup ) {
            push @errors, { id => "access", msg => "Access denied for [catalog.documents.create:*]"}
                unless ($c->access->Check("catalog.documents.create:*",  $i_workgroup));
        }

        if ( $i_fascicle && $i_fascicle ne "00000000-0000-0000-0000-000000000000") {
            push @errors, { id => "access", msg => "Access denied for [editions.documents.assign]"}
                unless ($c->access->Check("editions.documents.assign", $i_edition));
        }

        if ($current_member ne $manager) {
            push @errors, { id => "access", msg => "Access denied for [catalog.documents.assign:*]"}
                unless ($c->access->Check("catalog.documents.assign:*",  $i_workgroup));
        }
    }

    unless ( @errors ) {

        push @fields, "id";
        push @data, $id;

        push @fields, "copygroup";
        push @data, $id;

        push @fields, "movegroup";
        push @data, $id;

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

        push @fields, "fdate";
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

    }

    my $edition;
    unless ( @errors ) {
        # Set edition

        $edition = $c->sql->Q(" SELECT id, path, shortcut FROM editions WHERE id = ?", [ $i_edition ])->Hash;

        if ($edition->{id} && $edition->{shortcut}) {
            push @fields, "edition";
            push @data, $edition->{id};
            push @fields, "edition_shortcut";
            push @data, $edition->{shortcut};
            # Set ineditions[]
            my $editions = $c->sql->Q("
                SELECT ARRAY( select id from editions where path @> ( select path from editions where id = ? ) )
            ", [ $edition->{id} ])->Array;
            push @fields, "ineditions";
            push @data, $editions;
        }

        push @errors, { id => "edition", msg => "Object not found"}
            unless ($edition);
    }

    my $workgroup;
    unless ( @errors ) {
        # Set Workgroup
        $workgroup = $c->sql->Q(" SELECT id, shortcut FROM catalog WHERE id = ?", [ $i_workgroup ])->Hash;

        push @fields, "workgroup";
        push @data, $workgroup->{id};

        push @fields, "workgroup_shortcut";
        push @data, $workgroup->{shortcut};

        push @errors, { id => "workgroup", msg => "Object not found"}
            unless ($workgroup);
    }

    unless ( @errors ) {
        # Set Inworkgroups[]
        my $workgroups = $c->sql->Q(" SELECT ARRAY( select id from catalog where path @> ( select path from catalog where id = ? ) ) ", [ $workgroup->{id} ])->Array;
        push @fields, "inworkgroups";
        push @data, $workgroups;

        push @errors, { id => "workgroups", msg => "Object not found"}
            unless ($workgroups);
    }

    unless ( @errors ) {
        # Creator
        push @fields, "creator";
        push @fields, "creator_shortcut";
        push @data, $c->QuerySessionGet("member.id");
        push @data, $c->QuerySessionGet("member.shortcut") || "<Unknown>";
    }

    my $manager_obj;
    unless ( @errors ) {
        # Set manager
        $manager_obj = $c->sql->Q(" SELECT id, shortcut FROM view_principals WHERE id = ?", [ $manager ])->Hash;

        push @fields, "manager";
        push @fields, "manager_shortcut";
        push @data, $manager_obj->{id};
        push @data, $manager_obj->{shortcut};

        push @errors, { id => "manager", msg => "Object not found"}
            unless ($manager_obj->{id});
    }

    unless ( @errors ) {
        # Set Holder
        my $holder = $c->sql->Q(" SELECT id, shortcut FROM view_principals WHERE id = ?", [ $manager_obj->{id} ])->Hash;
        push @fields, "holder";
        push @fields, "holder_shortcut";
        push @data, $holder->{id};
        push @data, $holder->{shortcut};

        push @errors, { id => "holder", msg => "Object not found"}
            unless ($holder);
    }

    unless ( @errors ) {
        my $stage = $c->sql->Q("
            SELECT
                t1.id as branch, t1.shortcut as branch_shortcut,
                t2.id as stage, t2.shortcut as stage_shortcut,
                t3.id as readiness, t3.shortcut as readiness_shortcut, t3.color, t3.weight as progress
                FROM branches t1, stages t2, readiness t3
            WHERE edition = ? AND t2.branch = t1.id AND t3.id = t2.readiness
            ORDER BY t2.weight LIMIT 1
        ", [ $i_edition ])->Hash;

        push @errors, { id => "stage", msg => "Object not found"}
            unless ($stage);

        if ($stage->{stage}) {

            # Set Branch
            push @fields, "branch";
            push @fields, "branch_shortcut";
            push @data, $stage->{branch};
            push @data, $stage->{branch_shortcut};

            # Set Stage
            push @fields, "stage";
            push @fields, "stage_shortcut";
            push @data, $stage->{stage};
            push @data, $stage->{stage_shortcut};

            # Set Readiness
            push @fields, "readiness";
            push @fields, "readiness_shortcut";
            push @data, $stage->{readiness};
            push @data, $stage->{readiness_shortcut};

            # Set Color
            push @fields, "color";
            push @data, $stage->{color};

            # Set Progress
            push @fields, "progress";
            push @data, $stage->{progress};
        }
    }

    # Fascicle, && Headline && Rubric
    unless ( @errors ) {

        my $fascicle = $c->sql->Q(" SELECT id, shortcut FROM fascicles WHERE id = ?", [ $i_fascicle ])->Hash;

        push @errors, { id => "fascicle", msg => "Object not found"}
            unless ($fascicle);

        if ($fascicle->{id} && $fascicle->{shortcut}) {

            push @fields, "fascicle";
            push @fields, "fascicle_shortcut";
            push @data, $fascicle->{id};
            push @data, $fascicle->{shortcut};

            if ($i_headline) {

                undef my $headline;
                if ($fascicle->{id} ne "00000000-0000-0000-0000-000000000000") {
                    $headline = Inprint::Utils::GetHeadlineById($c, id => $i_headline, fascicle => $fascicle->{id} );
                }

                my $editions = $c->sql->Q(" SELECT id FROM editions WHERE path @> ? order by path asc ", [ $edition->{path} ])->Values;

                if ($fascicle->{id} eq "00000000-0000-0000-0000-000000000000") {

                    # find headline in index
                    my $source_headline = $c->sql->Q("
                        SELECT * FROM indx_headlines WHERE id=? AND edition=ANY(?) ",
                        [ $i_headline, $editions ])->Hash;

                    # find headline in fascicle
                    unless ($source_headline->{id}) {
                        $source_headline = $c->sql->Q("
                            SELECT * FROM fascicles_indx_headlines WHERE id=? AND edition=?",
                            [ $i_headline, $edition->{id} ])->Hash;
                    }

                    $headline = Inprint::Utils::Headlines::Create($c, $edition->{id}, $fascicle->{id}, $source_headline->{title}, $source_headline->{shortcut}, $source_headline->{description});
                }

                if ($headline->{id} && $headline->{shortcut}) {

                    push @fields, "headline";
                    push @fields, "headline_shortcut";
                    push @data, $headline->{id};
                    push @data, $headline->{shortcut};

                    if ($i_rubric) {

                        undef my $rubric;
                        if ($fascicle->{id} ne "00000000-0000-0000-0000-000000000000") {
                            $rubric   = Inprint::Utils::GetRubricById($c, id => $i_rubric, fascicle => $fascicle->{id});
                        }

                        if ($fascicle->{id} eq "00000000-0000-0000-0000-000000000000") {

                            # find headline in index
                            my $source_rubric = $c->sql->Q("
                                SELECT * FROM indx_rubrics WHERE id=? AND edition=ANY(?) ",
                                [ $i_rubric, $editions ])->Hash;

                            # find headline in fascicle
                            unless ($source_rubric->{id}) {
                                $source_rubric = $c->sql->Q("
                                    SELECT * FROM fascicles_indx_rubrics WHERE id=? AND edition=ANY(?)",
                                    [ $i_rubric, $editions ])->Hash;
                            }

                            $rubric   = Inprint::Utils::Rubrics::Create($c, $edition->{id}, $fascicle->{id}, $headline->{id}, $source_rubric->{title}, $source_rubric->{shortcut}, $source_rubric->{description});
                        }

                        if ($rubric->{id} && $rubric->{shortcut}) {
                            push @fields, "rubric";
                            push @fields, "rubric_shortcut";
                            push @data, $rubric->{id};
                            push @data, $rubric->{shortcut};
                        }
                    }
                }
            }
        }
    }

    # Create document
    unless (@errors) {
        my @placeholders; foreach (@data) { push @placeholders, "?"; }

        $c->sql->bt;

        $c->sql->Do(" INSERT INTO documents (" . ( join ",", @fields ) .") VALUES (". ( join ",", @placeholders ) .") ", \@data);

        my $document = $c->sql->Q(" SELECT * FROM documents WHERE id=? ", [ $id ])->Hash;

        $c->sql->Do("
            INSERT INTO history(
                entity, operation,
                color, weight,
                branch, branch_shortcut,
                stage, stage_shortcut,
                sender, sender_shortcut,
                sender_catalog, sender_catalog_shortcut,
                destination, destination_shortcut,
                destination_catalog, destination_catalog_shortcut,
                created)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, now());
        ", [
            $document->{id}, "create",
            $document->{color}, $document->{progress},
            $document->{branch}, $document->{branch_shortcut},
            $document->{stage}, $document->{stage_shortcut},

            $document->{creator}, $document->{creator_shortcut},
            $document->{workgroup}, $document->{workgroup_shortcut},

            $document->{creator}, $document->{creator_shortcut},
            $document->{workgroup}, $document->{workgroup_shortcut},
        ]);

        $c->sql->Do("
            INSERT INTO history(
                entity, operation,
                color, weight,
                branch, branch_shortcut,
                stage, stage_shortcut,
                sender, sender_shortcut,
                sender_catalog, sender_catalog_shortcut,
                destination, destination_shortcut,
                destination_catalog, destination_catalog_shortcut,
                created)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, now());
        ", [
            $document->{id}, "transfer",
            $document->{color}, $document->{progress},
            $document->{branch}, $document->{branch_shortcut},
            $document->{stage}, $document->{stage_shortcut},

            $document->{creator}, $document->{creator_shortcut},
            $document->{workgroup}, $document->{workgroup_shortcut},

            $document->{manager}, $document->{manager_shortcut},
            $document->{workgroup}, $document->{workgroup_shortcut},
        ]);

        $c->sql->et;
    }

    $success = $c->json->true unless (@errors);
    $c->render_json( { success => $success, errors => \@errors } );
}

sub update {

    my $c = shift;

    my $i_id      = $c->param("id");
    my $i_title   = $c->param("title");
    my $i_author  = $c->param("author");
    my $i_size    = $c->param("size") || 0;
    my $i_enddate = $c->param("enddate");

    my $i_headline = $c->param("headline");
    my $i_rubric   = $c->param("rubric");

    my @errors;
    my $success = $c->json->false;

    push @errors, { id => "id", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_id));

    push @errors, { id => "title", msg => "Incorrectly filled field"}
        unless ($c->is_text($i_title));

    if ($i_author) {
        push @errors, { id => "author", msg => "Incorrectly filled field"}
            unless ($c->is_text($i_author));
    }

    if ($i_size) {
        push @errors, { id => "size", msg => "Incorrectly filled field"}
            unless ($c->is_int($i_size));
    }

    if ($i_enddate) {
        push @errors, { id => "enddate", msg => "Incorrectly filled field"}
            unless ($c->is_date($i_enddate));
    }

    my $document = Inprint::Utils::GetDocumentById($c, id => $i_id);
    push @errors, { id => "document", msg => "Can't find document object"}
        unless ($document->{id});

    undef my $headline;
    undef my $rubric;

    if ($i_headline) {

        if ($document->{fascicle} ne "00000000-0000-0000-0000-000000000000") {
            $headline = Inprint::Utils::GetHeadlineById($c, id => $i_headline, fascicle => $document->{fascicle} );
        }

        if ($document->{fascicle} eq "00000000-0000-0000-0000-000000000000") {

            my $editions = $c->sql->Q("
                SELECT id FROM editions WHERE path @> (SELECT path FROM editions WHERE id=?) order by path asc ",
                [ $document->{edition} ])->Values;

            # find headline in index
            my $source_headline = $c->sql->Q("
                SELECT * FROM indx_headlines WHERE id=? AND edition=ANY(?) ",
                [ $i_headline, $editions ])->Hash;

            # find headline in fascicle
            unless ($source_headline) {
                $source_headline = $c->sql->Q("
                    SELECT * FROM fascicles_indx_headlines WHERE id=? AND edition=?",
                    [ $i_headline, $document->{edition} ])->Hash;
            }

            $headline = Inprint::Utils::Headlines::Create($c, $document->{edition}, $document->{fascicle}, $source_headline->{title}, $source_headline->{shortcut}, $source_headline->{description});

        }

        # Process rubric
        if ($i_rubric) {

            if ($document->{fascicle} ne "00000000-0000-0000-0000-000000000000") {
                $rubric   = Inprint::Utils::GetRubricById($c, id => $i_rubric, fascicle => $document->{fascicle});
            }

            if ($document->{fascicle} eq "00000000-0000-0000-0000-000000000000") {

                my $editions = $c->sql->Q("
                    SELECT id FROM editions WHERE path @> (SELECT path FROM editions WHERE id=?) order by path asc ",
                    [ $document->{edition} ])->Values;

                # find headline in index
                my $source_rubric = $c->sql->Q("
                    SELECT * FROM indx_rubrics WHERE id=? AND edition=ANY(?) ",
                    [ $i_rubric, $editions ])->Hash;

                # find headline in fascicle
                unless ($source_rubric) {
                    $source_rubric = $c->sql->Q("
                        SELECT * FROM fascicles_indx_rubrics WHERE id=? AND edition=?",
                        [ $i_rubric, $document->{edition} ])->Hash;
                }

                $rubric   = Inprint::Utils::Rubrics::Create($c, $document->{edition}, $document->{fascicle}, $headline->{id}, $source_rubric->{title}, $source_rubric->{shortcut}, $source_rubric->{description});
            }

        }

    }

    unless ($headline->{id}) {
        $headline   = Inprint::Utils::Headlines::Create($c, $document->{edition}, $document->{fascicle}, "--", "--", "--");
    }

    push @errors, { id => "headline", msg => "Can't find headline object"}
        unless ($headline->{id});

    unless ($rubric->{id}) {
        $rubric   = Inprint::Utils::Rubrics::Create($c, $document->{edition}, $document->{fascicle}, $headline->{id}, "--", "--", "--");
    }

    push @errors, { id => "rubric", msg => "Can't find rubric object"}
        unless ($rubric->{id});

    unless (@errors) {
        push @errors, { id => "access", msg => "Not enough permissions"}
            unless ($c->access->Check("catalog.documents.update:*", $document->{workgroup}));
    }

    unless (@errors) {

        # Update workgroup

        $c->sql->Do(" UPDATE documents SET title=?, author=?, psize=?, pdate=? WHERE id=? OR copygroup=?; ",
            [ $i_title, $i_author, $i_size, $i_enddate, $document->{id}, $document->{id} ]);

        # Update document

        #$c->sql->Do(" UPDATE documents SET title=?, author=?, psize=?, pdate=? WHERE id=? OR copygroup=?; ",
        #    [ $i_title, $i_author, $i_size, $i_enddate, $document->{id}, $document->{id} ]);

        # Update headline and rubric
        if ($headline->{id}) {
            $c->sql->Do(" UPDATE documents SET headline=?, headline_shortcut=? WHERE id=? ", [ $headline->{id}, $headline->{shortcut}, $document->{id} ]);
            if ($rubric->{id}) {
                $c->sql->Do(" UPDATE documents SET rubric=?, rubric_shortcut=? WHERE id=? ", [ $rubric->{id}, $rubric->{shortcut}, $document->{id} ]);
            } else {
                $c->sql->Do(" UPDATE documents SET rubric=null, rubric_shortcut=null WHERE id=? ", [ $document->{id} ]);
            }

        } else {
            $c->sql->Do(" UPDATE documents SET headline=null, headline_shortcut=null WHERE id=? ", [ $document->{id} ]);
            $c->sql->Do(" UPDATE documents SET rubric=null, rubric_shortcut=null WHERE id=? ; ", [ $document->{id} ]);
        }

        # Update indexation
        Inprint::Utils::Documents::MoveDocumentIndexToFascicle($c, \@errors, $document->{id});
    }

    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors });
}



sub capture {
    my $c = shift;
    my @ids = $c->param("id");

    my @errors;
    my $success = $c->json->false;

    my $current_user      = $c->QuerySessionGet("member.id");
    my $default_edition   = $c->QuerySessionGet("options.default.edition");
    my $default_workgroup = $c->QuerySessionGet("options.default.workgroup");

    my $member    = $c->sql->Q(" SELECT id, shortcut FROM profiles WHERE id=? ", [ $current_user ])->Hash;
    my $edition   = $c->sql->Q(" SELECT id, shortcut FROM editions WHERE id=? ", [ $default_edition ])->Hash;
    my $workgroup = $c->sql->Q(" SELECT id, shortcut FROM catalog WHERE id=? ", [ $default_workgroup ])->Hash;

    push @errors, { id => "member", msg => "Can't find object"}
        unless ( $member->{id} || $member->{shortcut} );

    push @errors, { id => "edition", msg => "Can't find object"}
        unless ( $edition->{id} || $edition->{shortcut} );

    push @errors, { id => "workgroup", msg => "Can't find object"}
        unless ( $workgroup->{id} || $workgroup->{shortcut} );

    unless(@errors) {
        foreach my $id (@ids) {

            $success = $c->json->true;

            my $document = $c->sql->Q(" SELECT * FROM documents WHERE id=? ", [ $id ])->Hash;

            next unless ($document->{id});

            $c->sql->bt;

            my $workgroups = $c->sql->Q("
                SELECT ARRAY( select id from catalog where path @> ( select path from catalog where id = ? ) )
            ", [ $workgroup->{id} ])->Array;

            $c->sql->Do("
                UPDATE documents SET
                    holder=?, holder_shortcut=?,
                    workgroup=?, workgroup_shortcut=?, inworkgroups=?,
                    fdate=now()
                WHERE id=?
            ", [
                $member->{id}, $member->{shortcut},
                $workgroup->{id}, $workgroup->{shortcut}, $workgroups,
                $document->{id}
            ]);

            $c->sql->Do("
                INSERT INTO history(
                    entity, operation,
                    color, weight,
                    branch, branch_shortcut,
                    stage, stage_shortcut,
                    sender, sender_shortcut,
                    sender_catalog, sender_catalog_shortcut,
                    destination, destination_shortcut,
                    destination_catalog, destination_catalog_shortcut,
                    created)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, now());
            ", [
                $document->{id}, "transfer",

                $document->{color}, $document->{progress},
                $document->{branch}, $document->{branch_shortcut},
                $document->{stage}, $document->{stage_shortcut},

                $document->{creator}, $document->{creator_shortcut},
                $document->{workgroup}, $document->{workgroup_shortcut},

                $member->{id}, $member->{shortcut},
                $workgroup->{id}, $workgroup->{shortcut},
            ]);

            $c->sql->et;
        }
    }

    $success = $c->json->true unless (@errors);
    $c->render_json( { success => $success, errors => \@errors } );
}

sub transfer {
    my $c = shift;

    my @ids = $c->param("id");
    my $transfer = $c->param("transfer");

    my @errors;
    my $success = $c->json->false;

    push @errors, { id => "transfer", msg => "Can't find object"}
        unless ($c->is_uuid($transfer));

    # Check sender
    my $current_member = $c->QuerySessionGet("member.id");
    my $sender = $c->sql->Q(" SELECT * FROM profiles WHERE id = ? ", [ $current_member ])->Hash;
    push @errors, { id => "sender", msg => "Can't find object"}
        unless ($c->is_uuid($sender->{id}));

    # Check assigment
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
    ", [ $transfer ])->Hash;

    push @errors, { id => "assignment", msg => "Can't find object"}
        unless ( $assignment->{id} );

    unless (@errors) {

        foreach my $id (@ids) {

            # TODO: Add access check

            my $document = $c->sql->Q(" SELECT * FROM documents WHERE id=? ", [ $id ])->Hash;

            next unless ($document->{id});

            my $workgroups = $c->sql->Q("
                SELECT ARRAY( select id from catalog where path @> ( select path from catalog where id = ? ) )
            ", [ $assignment->{catalog} ])->Array;

            $c->sql->bt;

            if ($assignment->{principal_type} eq "group") {
                $assignment->{catalog} = $assignment->{principal};
                $assignment->{catalog_shortcut} = $assignment->{principal_shortcut};
            }

            $c->sql->Do("
                UPDATE documents SET
                    holder=?, holder_shortcut=?,
                    workgroup=?, workgroup_shortcut=?, inworkgroups=?,
                    readiness=?, readiness_shortcut=?, color=?, progress=?, fdate=now()
                WHERE id=?
            ", [
                $assignment->{principal}, $assignment->{principal_shortcut},
                $assignment->{catalog}, $assignment->{catalog_shortcut}, $workgroups,
                $assignment->{readiness}, $assignment->{readiness_shortcut},
                $assignment->{color}, $assignment->{progress},
                $id
            ]);

            $c->sql->Do("
                INSERT INTO history(
                    entity, operation,
                    color, weight,
                    branch, branch_shortcut,
                    stage, stage_shortcut,
                    sender, sender_shortcut,
                    sender_catalog, sender_catalog_shortcut,
                    destination, destination_shortcut,
                    destination_catalog, destination_catalog_shortcut,
                    created)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, now());
            ", [
                $document->{id}, "transfer",
                $assignment->{color}, $assignment->{progress},
                $assignment->{branch}, $assignment->{branch_shortcut},
                $assignment->{stage}, $assignment->{stage_shortcut},
                $sender->{id}, $sender->{shortcut},
                $document->{workgroup}, $document->{workgroup_shortcut},
                $assignment->{principal}, $assignment->{principal_shortcut},
                $assignment->{catalog}, $assignment->{catalog_shortcut},
            ]);

            $c->sql->et;
        }
    }

    $success = $c->json->true unless (@errors);
    $c->render_json( { success => $success, errors => \@errors } );
}

sub briefcase {
    my $c = shift;

    my @ids = $c->param("id");

    my @errors;
    my $success = $c->json->false;

    my $fascicle = $c->sql->Q(" SELECT id, shortcut FROM fascicles WHERE id='00000000-0000-0000-0000-000000000000' ")->Hash;

    if ($fascicle) {
        foreach my $id (@ids) {
            $c->sql->bt;

            my $document = $c->sql->Q(" SELECT * FROM documents WHERE id=? ", [ $id ])->Hash;

            next unless ($document->{id});

            $c->sql->Do(" DELETE FROM fascicles_map_documents WHERE fascicle=? AND entity=? ", [ $document->{fascicle}, $document->{id} ]);
            $c->sql->Do(" UPDATE documents SET fascicle=?, fascicle_shortcut=? WHERE id=? ", [ $fascicle->{id}, $fascicle->{shortcut}, $document->{id} ]);
            Inprint::Utils::Documents::MoveDocumentIndexToFascicle($c, \@errors, $document->{id});

            $c->sql->et;
        }
    }

    $success = $c->json->true unless (@errors);
    $c->render_json( { success => $success, errors => \@errors } );
}

sub move {
    my $c = shift;

    my @ids = $c->param("id");

    #my $i_edition  = $c->param("edition");
    my $i_fascicle = $c->param("fascicle");
    my $i_headline = $c->param("headline");
    my $i_rubric   = $c->param("rubric");
    my $i_change   = $c->param("ch-rub");

    my @errors;
    my $success = $c->json->false;

    #push @errors, { id => "edition", msg => "Incorrectly filled field"}
    #    unless ($c->is_uuid($i_edition));

    push @errors, { id => "fascicle", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_fascicle));

    my $fascicle = Inprint::Utils::GetFascicleById($c, id => $i_fascicle);
    push @errors, { id => "fascicle", msg => "Can't find object"}
        unless ( $fascicle->{id} || $fascicle->{shortcut} );

    my $i_edition = $fascicle->{edition};

    if ($i_fascicle && $i_fascicle ne  "00000000-0000-0000-0000-000000000000") {
        $i_edition = $c->sql->Q(" SELECT edition FROM fascicles WHERE id = ?", [ $fascicle->{id} ])->Value;
        push @errors, { id => "edition", msg => "Incorrectly filled field"}
            unless ($c->is_uuid($i_edition));
    }

    my $edition  = Inprint::Utils::GetEditionById($c, id => $i_edition );
    push @errors, { id => "edition", msg => "Can't find object"}
        unless ( $edition->{id} || $edition->{shortcut} );

    my $headline = Inprint::Utils::GetHeadlineById($c, id => $i_headline, fascicle => $i_fascicle);
    my $rubric   = Inprint::Utils::GetRubricById($c,   id => $i_rubric,   headline=> $i_headline);

    unless (@errors) {

        foreach my $id (@ids) {

            my $document = $c->sql->Q(" SELECT * FROM documents WHERE id=? ", [ $id ])->Hash;

            next unless ($document->{id});

            # Remove document from old fascicle composition
            if ($document->{fascicle} ne $fascicle->{id}) {
                $c->sql->Do(" DELETE FROM fascicles_map_documents WHERE fascicle=? AND entity=? ", [ $document->{fascicle}, $document->{id} ]);
            }

            # Change fascicle to new
            $c->sql->Do(" UPDATE documents SET edition=?,  edition_shortcut=?  WHERE id=? ", [ $edition->{id}, $edition->{shortcut}, $document->{id} ]);
            $c->sql->Do(" UPDATE documents SET fascicle=?, fascicle_shortcut=? WHERE id=? ", [ $fascicle->{id}, $fascicle->{shortcut}, $document->{id} ]);

            # Change headline to new
            if ($i_change eq "yes") {
                if ($headline->{id}) {
                    $c->sql->Do(" UPDATE documents SET headline=?, headline_shortcut=? WHERE id=? ", [ $headline->{id}, $headline->{shortcut}, $document->{id} ]);
                    if ($rubric->{id}) {
                        $c->sql->Do(" UPDATE documents SET rubric=?, rubric_shortcut=? WHERE id=? ", [ $rubric->{id}, $rubric->{shortcut}, $document->{id} ]);
                    }
                }
            }

            # Update indexation
            Inprint::Utils::Documents::MoveDocumentIndexToFascicle($c, \@errors, $id);

        }
    }

    $success = $c->json->true unless (@errors);
    $c->render_json( { success => $success, errors => \@errors } );
}

sub copy {
    my $c = shift;

    my @ids = $c->param("id");
    my @copies = $c->param("copyto");

    my @errors;
    my $success = $c->json->false;

    foreach my $copyid (@copies) {

        my ($fascicle_id, $headline_id, $rubric_id) = split '::', $copyid;

        my $fascicle = Inprint::Utils::GetFascicleById($c, id => $fascicle_id);
        next unless $fascicle->{id};

        my $edition  = Inprint::Utils::GetEditionById($c, id => $fascicle->{edition});
        next unless $edition->{id};

        my $headline = Inprint::Utils::GetHeadlineById($c, id => $headline_id);
        my $rubric   = Inprint::Utils::GetRubricById($c,   id => $rubric_id);

        foreach my $document_id (@ids) {

            my $document = $c->sql->Q("SELECT * FROM documents WHERE id=?", [ $document_id ])->Hash;
            my $exist = $c->sql->Q("SELECT true FROM documents WHERE copygroup=? AND fascicle=?", [ $document->{id}, $fascicle->{id} ])->Value;

            if ( $document->{id} ) {

                unless ($exist) {

                    my $new_id = $c->uuid();

                    $c->sql->bt();

                    $c->sql->Do("
                        INSERT INTO documents(
                            id,
                            creator, creator_shortcut,
                            holder, holder_shortcut,
                            manager, manager_shortcut,
                            edition, edition_shortcut, ineditions,
                            copygroup,
                            workgroup, workgroup_shortcut, inworkgroups,
                            fascicle, fascicle_shortcut,
                            headline, headline_shortcut,
                            rubric, rubric_shortcut,
                            branch, branch_shortcut,
                            stage, stage_shortcut,
                            readiness, readiness_shortcut,
                            color, progress,
                            title, author,
                            pdate, psize,
                            fdate, rsize,
                            filepath,
                            images, files,
                            islooked, isopen,
                            created, updated
                        )
                        VALUES (
                            ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,
                            ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, now(), now()
                        );
                    ", [
                        $new_id,
                            $document->{creator}, $document->{creator_shortcut},
                            $document->{holder},  $document->{holder_shortcut},
                            $document->{manager}, $document->{manager_shortcut},
                            $document->{edition}, $document->{edition_shortcut},  $document->{ineditions},
                        $document->{copygroup},
                            $document->{workgroup}, $document->{workgroup_shortcut}, $document->{inworkgroups},
                            $document->{fascicle}, $document->{fascicle_shortcut},
                            $document->{headline}, $document->{headline_shortcut},
                            $document->{rubric}, $document->{rubric_shortcut},
                            $document->{branch}, $document->{branch_shortcut},
                            $document->{stage}, $document->{stage_shortcut},
                            $document->{readiness}, $document->{readiness_shortcut}, $document->{color}, $document->{progress},
                            $document->{title}, $document->{author},
                            $document->{pdate}, $document->{psize},
                            $document->{fdate}, $document->{rsize},
                            $document->{filepath},
                            $document->{images}, $document->{files},
                            $document->{islooked}, $document->{isopen}
                    ]);

                    # Change Edition
                    my $editions = $c->sql->Q("
                        SELECT ARRAY( select id from editions where path @> ( select path from editions where id = ? ) )
                    ", [ $edition->{id} ])->Array;
                    $c->sql->Do(" UPDATE documents SET edition=?, edition_shortcut=?, ineditions=? WHERE id=? ", [ $edition->{id}, $edition->{shortcut}, $editions, $new_id ]);

                    # Change Fascicle
                    $c->sql->Do(" UPDATE documents SET fascicle=?, fascicle_shortcut=? WHERE id=? ", [ $fascicle->{id}, $fascicle->{shortcut}, $new_id ]);

                    if ($headline->{id}) {
                        $c->sql->Do(" UPDATE documents SET headline=?, headline_shortcut=? WHERE id=? ", [ $headline->{id}, $headline->{shortcut}, $new_id ]);
                    }

                    if ($rubric->{id}) {
                        $c->sql->Do(" UPDATE documents SET rubric=?, rubric_shortcut=? WHERE id=? ", [ $rubric->{id}, $rubric->{shortcut}, $new_id ]);
                    }

                    # Change Index
                    Inprint::Utils::Documents::MoveDocumentIndexToFascicle($c, \@errors, $new_id);

                    $c->sql->et();
                }
            }
        }
    }

    $success = $c->json->true unless (@errors);
    $c->render_json( { success => $success, errors => \@errors } );
}

sub duplicate {

    my $c = shift;

    my @ids = $c->param("id");
    my @copies = $c->param("copyto");

    my @errors;
    my $success = $c->json->false;

    foreach my $copyid (@copies) {

        my ($fascicle_id, $headline_id, $rubric_id) = split '::', $copyid;

        my $fascicle = Inprint::Utils::GetFascicleById($c, id => $fascicle_id);
        next unless $fascicle->{id};

        my $edition  = Inprint::Utils::GetEditionById($c, id => $fascicle->{edition});
        next unless $edition->{id};

        my $headline = Inprint::Utils::GetHeadlineById($c, id => $headline_id);
        my $rubric   = Inprint::Utils::GetRubricById($c,   id => $rubric_id);

        foreach my $document_id (@ids) {

            my $document = $c->sql->Q("SELECT * FROM documents WHERE id=?", [ $document_id ])->Hash;
            #my $exist = $c->sql->Q("SELECT true FROM documents WHERE copygroup=? AND fascicle=?", [ $document->{id}, $fascicle->{id} ])->Value;

            if ( $document->{id} ) {

                my $new_id = $c->uuid();

                #filepath
                my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
                $year += 1900;
                $mon += 1;
                my $filepath = "/$year/$mon/$new_id";

                $c->sql->bt;

                $c->sql->Do("
                    INSERT INTO documents(
                        id,
                        creator, creator_shortcut,
                        holder, holder_shortcut,
                        manager, manager_shortcut,
                        edition, edition_shortcut, ineditions,
                        copygroup, movegroup,
                        workgroup, workgroup_shortcut, inworkgroups,
                        fascicle, fascicle_shortcut,
                        headline, headline_shortcut,
                        rubric, rubric_shortcut,
                        branch, branch_shortcut,
                        stage, stage_shortcut,
                        readiness, readiness_shortcut,
                        color, progress,
                        title, author,
                        pdate, psize,
                        fdate, rsize,
                        filepath,
                        images, files,
                        islooked, isopen,
                        created, updated
                    )
                    VALUES (
                        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,
                        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, now(), now()
                    );
                ", [
                    $new_id,
                        $document->{creator}, $document->{creator_shortcut},
                        $document->{holder},  $document->{holder_shortcut},
                        $document->{manager}, $document->{manager_shortcut},
                        $document->{edition}, $document->{edition_shortcut},  $document->{ineditions},
                        $new_id, $document->{movegroup} || $new_id,
                        $document->{workgroup}, $document->{workgroup_shortcut}, $document->{inworkgroups},
                        $document->{fascicle}, $document->{fascicle_shortcut},
                        $document->{headline}, $document->{headline_shortcut},
                        $document->{rubric}, $document->{rubric_shortcut},
                        $document->{branch}, $document->{branch_shortcut},
                        $document->{stage}, $document->{stage_shortcut},
                        $document->{readiness}, $document->{readiness_shortcut}, $document->{color}, $document->{progress},
                        $document->{title}, $document->{author},
                        $document->{pdate}, $document->{psize},
                        $document->{fdate}, $document->{rsize},
                        $filepath,
                        $document->{images}, $document->{files},
                        $document->{islooked}, $document->{isopen}
                ]);

                # Change Edition
                my $editions = $c->sql->Q("
                    SELECT ARRAY( select id from editions where path @> ( select path from editions where id = ? ) )
                ", [ $edition->{id} ])->Array;
                $c->sql->Do(" UPDATE documents SET edition=?, edition_shortcut=?, ineditions=? WHERE id=? ", [ $edition->{id}, $edition->{shortcut}, $editions, $new_id ]);

                # Change Fascicle
                $c->sql->Do(" UPDATE documents SET fascicle=?, fascicle_shortcut=? WHERE id=? ", [ $fascicle->{id}, $fascicle->{shortcut}, $new_id ]);

                if ($headline->{id}) {
                    $c->sql->Do(" UPDATE documents SET headline=?, headline_shortcut=? WHERE id=? ", [ $headline->{id}, $headline->{shortcut}, $new_id ]);
                }

                if ($rubric->{id}) {
                    $c->sql->Do(" UPDATE documents SET rubric=?, rubric_shortcut=? WHERE id=? ", [ $rubric->{id}, $rubric->{shortcut}, $new_id ]);
                }

                # Indexation
                Inprint::Utils::Documents::MoveDocumentIndexToFascicle($c, \@errors, $new_id);

                # Datastore

                my $storePath    = $c->config->get("store.path");
                my $old_path = Inprint::Utils::Files::ProcessFilePath($c, "$storePath/documents/$document->{filepath}");
                my $new_path = Inprint::Utils::Files::ProcessFilePath($c, "$storePath/documents/$filepath");

                if (-w $storePath) {
                    if (-r $old_path) {
                        rcopy($old_path, $new_path) || die "$!";
                    }
                }

                $c->sql->et;

            }
        }
    }

    $success = $c->json->true unless (@errors);
    $c->render_json( { success => $success, errors => \@errors } );
}

sub say {

    my $c = shift;
    my $i_id = $c->param("id");
    my $i_text = $c->param("text");

    my @errors;
    my $success = $c->json->false;

    push @errors, { id => "id", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_id));

    push @errors, { id => "text", msg => "Incorrectly filled field"}
        unless ($i_text);

    my $document;
    unless (@errors) {
        $document = $c->sql->Q(" SELECT * FROM documents WHERE id=? ", [ $i_id ])->Hash;
        push @errors, { id => "document", msg => "Can't find document object"}
                unless ($document->{id});
    }

    my $current_user = $c->QuerySessionGet("member.id");
    my $member;
    unless (@errors) {
        $member    = $c->sql->Q(" SELECT id, shortcut FROM profiles WHERE id=? ", [ $current_user ])->Hash;
        push @errors, { id => "document", msg => "Can't find document object"}
            unless ($member->{id});
    }

    unless (@errors) {

        $c->sql->Do("
                INSERT INTO comments(
                    path, entity, member, member_shortcut, stage, stage_shortcut, stage_color, fulltext, created, updated)
                VALUES (null, ?, ?, ?, ?, ?, ?, ?, now(), now() ) ", [
                $document->{id}, $member->{id}, $member->{shortcut}, $document->{stage}, $document->{stage_shortcut}, $document->{color}, $i_text
            ]);
    }

    $success = $c->json->true unless (@errors);
    $c->render_json( { success => $success, errors => \@errors } );
}

sub recycle {

    my $c = shift;

    my @ids = $c->param("id");

    my $fascicle = Inprint::Utils::GetFascicleById($c, id => '99999999-9999-9999-9999-999999999999');

    if ($fascicle) {
        foreach my $id (@ids) {

            if ($c->is_uuid($id)) {
                my $document = Inprint::Utils::GetDocumentById($c, id => $id);

                next unless ($document->{id});

                if ($document->{workgroup}) {
                    if ($c->access->Check("catalog.documents.delete:*", $document->{workgroup})) {

                        # Remove document from old fascicle composition
                        $c->sql->Do(" DELETE FROM fascicles_map_documents WHERE fascicle=? AND entity=? ", [ $document->{fascicle}, $document->{id} ]);

                        # Change document fascicle to sytem's Recycle fascicle
                        $c->sql->Do(" UPDATE documents SET fascicle=?, fascicle_shortcut=? WHERE id=? ", [ $fascicle->{id}, $fascicle->{shortcut}, $document->{id} ]);

                        # Update fascicle indexation
                        Inprint::Utils::Documents::MoveDocumentIndexToFascicle($c, [], $id);

                    }
                }
            }

        }
    }

    $c->render_json( { success => $c->json->true } );
}

sub restore {

    my $c = shift;

    my @ids = $c->param("id");

    my $fascicle = Inprint::Utils::GetFascicleById($c, id => '00000000-0000-0000-0000-000000000000');

    if ($fascicle) {
        foreach my $id (@ids) {
            if ($c->is_uuid($id)) {
                my $document = Inprint::Utils::GetDocumentById($c, id => $id);
                if ($document->{workgroup}) {
                    if ($c->access->Check("catalog.documents.delete:*", $document->{workgroup})) {
                        $c->sql->Do(" UPDATE documents SET fascicle=?, fascicle_shortcut=? WHERE id=? ", [ $fascicle->{id}, $fascicle->{shortcut}, $document->{id} ]);
                        Inprint::Utils::Documents::MoveDocumentIndexToFascicle($c, [], $id);
                    }
                }
            }
        }
    }
    $c->render_json( { success => $c->json->true } );
}

sub delete {
    my $c = shift;
    my @ids = $c->param("id");
    # TODO: this function

    $c->render_json( { success => $c->json->true } );
}



1;
