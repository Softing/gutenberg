package Inprint::Documents;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use File::Copy::Recursive qw(fcopy rcopy dircopy fmove rmove dirmove);

use Inprint::Check;

use Inprint::Utils;
use Inprint::Utils::Files;

use Inprint::Models::Tag;
use Inprint::Models::Documents;
use Inprint::Models::Fascicle::Rubric;
use Inprint::Models::Fascicle::Rubric;

use Inprint::Store::Embedded;
use Inprint::Store::Cache;

use base 'Inprint::BaseController';

# Read document
sub read {

    my $c = shift;

    my $i_id = $c->param("id");

    my @errors;
    my $success = $c->json->false;

    Inprint::Check::uuid($c, \@errors, "id", $i_id);

    my $document;
    unless (@errors) {
        $document = Inprint::Models::Documents::read($c, $i_id);
    }

    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors, data => $document || {} });
}

# Get documents list

sub array {
    my ($c, $params) = @_;

    my $searchResult = Inprint::Models::Documents::search($c, $params);

    my $total = $searchResult->{total};
    my $records = $searchResult->{result};

    my @columns = (
        'id', 'access',
        'edition',  'edition_shortcut',
        'fascicle', 'fascicle_shortcut',
        'headline', 'headline_shortcut',
        'rubric', 'rubric_shortcut',
        'copygroup',
        'holder','creator','manager','holder_shortcut','creator_shortcut','manager_shortcut',
        'maingroup','maingroup_shortcut',
        'workgroup','workgroup_shortcut','ingroups',
        'islooked','isopen',
        'branch','branch_shortcut','stage','stage_shortcut','color','progress',
        'title','author','pages',
        'pdate','psize','rdate','rsize',
        'images','files', 'links',
        'created',
        'updated',
        'uploaded',
        'moved');

    my @result;
    foreach my $record (@$records) {
        my @row;
        foreach my $column (@columns) {
            push @row, $record->{$column};
        }
        push @result, \@row;
    }

    $c->render_json( { "data" => \@result, "total" => $total } );
}

sub list {
    my ($c, $params) = @_;

    my $searchResult = Inprint::Models::Documents::search($c, $params);

    my $total = $searchResult->{total};
    my $records = $searchResult->{result};

    $c->render_json( { "data" => $records, "total" => $total } );
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

    Inprint::Check::text($c, \@errors, "title", $i_title);
    Inprint::Check::date($c, \@errors, "enddate", $i_enddate);
    Inprint::Check::uuid($c, \@errors, "edition", $i_edition);
    Inprint::Check::uuid($c, \@errors, "workgroup", $i_workgroup);
    Inprint::Check::uuid($c, \@errors, "manager", $manager);
    Inprint::Check::uuid($c, \@errors, "fascicle", $i_fascicle);

    # Check user access to this function
    unless ( @errors ) {
        if ( $i_workgroup ) {
            Inprint::Check::access($c, \@errors, "catalog.documents.create:*",  $i_workgroup);
        }
        if ( $i_fascicle && $i_fascicle ne "00000000-0000-0000-0000-000000000000") {
            Inprint::Check::access($c, \@errors, "editions.documents.assign", $i_edition);
        }
        if ($current_member ne $manager) {
            Inprint::Check::access($c, \@errors, "catalog.documents.assign:*",  $i_workgroup);
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
        push @data, Inprint::Store::Embedded::getFolderPath($c, "documents", "$year-$mon", $id, 1);

    }

    my $edition = Inprint::Check::edition($c, \@errors, $i_edition);
    unless ( @errors ) {

        push @fields, "edition";
        push @data, $edition->{id};
        push @fields, "edition_shortcut";
        push @data, $edition->{shortcut};

        # Set ineditions[]
        my $editions = $c->sql->Q("
            SELECT ARRAY( select id from editions where path @> ( select path from editions where id = ? ) ) ",
            [ $edition->{id} ])->Array;

        push @fields, "ineditions";
        push @data, $editions;

    }

    my $workgroup = Inprint::Check::department($c, \@errors, $i_workgroup);
    unless ( @errors ) {

        push @fields, "workgroup";
        push @data, $workgroup->{id};

        push @fields, "workgroup_shortcut";
        push @data, $workgroup->{shortcut};

        push @fields, "maingroup";
        push @data, $workgroup->{id};

        push @fields, "maingroup_shortcut";
        push @data, $workgroup->{shortcut};

        # Set Inworkgroups[]
        my $workgroups = $c->sql->Q("
            SELECT ARRAY( select id from catalog where path @> ( select path from catalog where id = ? ) ) ",
            [ $workgroup->{id} ])->Array;

        push @fields, "inworkgroups";
        push @data, $workgroups;

    }

    unless ( @errors ) {
        push @fields, "creator";
        push @fields, "creator_shortcut";
        push @data, $c->QuerySessionGet("member.id");
        push @data, $c->QuerySessionGet("member.shortcut") || "<Unknown>";
    }

    my $holder = Inprint::Check::principal($c, \@errors, $manager);
    unless ( @errors ) {
        push @fields, "manager";
        push @data, $holder->{id};

        push @fields, "manager_shortcut";
        push @data, $holder->{shortcut};

        push @fields, "holder";
        push @data, $holder->{id};

        push @fields, "holder_shortcut";
        push @data, $holder->{shortcut};
    }

    my $stage; unless ( @errors ) {

        my $parents = $c->sql->Q(" SELECT id FROM editions WHERE path @> ?", [ $edition->{path} ])->Values;

        $stage = $c->sql->Q("
            SELECT
                t1.id as branch, t1.shortcut as branch_shortcut,
                t2.id as stage, t2.shortcut as stage_shortcut,
                t3.id as readiness, t3.shortcut as readiness_shortcut, t3.color, t3.weight as progress
                FROM branches t1, stages t2, readiness t3
            WHERE edition = ANY(?) AND t2.branch = t1.id AND t3.id = t2.readiness
            ORDER BY t2.weight LIMIT 1
        ", [ $parents ])->Hash;

        push @errors, { id => "stage", msg => "Object not found"}
            unless ($stage);
    }

    unless ( @errors ) {

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

    # Fascicle
    my $fascicle = Inprint::Check::fascicle($c, \@errors, $i_fascicle);
    unless ( @errors ) {
        push @fields, "fascicle";
        push @fields, "fascicle_shortcut";
        push @data, $fascicle->{id};
        push @data, $fascicle->{shortcut};
    }

    # Rubrication
    my $headline; unless ( @errors ) {

        if ($i_headline) {

            $headline = $c->sql->Q("
                SELECT * FROM fascicles_indx_headlines WHERE fascicle=? AND tag=? ",
                [ $fascicle->{id}, $i_headline ])->Hash;

            push @errors, { id => "headline", msg => "Object not found"}
                unless ($headline->{id});

        }
    }

    my $rubric; unless ( @errors ) {

        if ($i_rubric) {

            $rubric = $c->sql->Q("
                SELECT * FROM fascicles_indx_rubrics WHERE fascicle=? AND tag=? ",
                [ $fascicle->{id}, $i_rubric ])->Hash;

            push @errors, { id => "rubric", msg => "Object not found"}
                unless ($rubric->{id});

        }
    }

    unless ( @errors ) {

        if ($headline->{id}) {
            my $tag = Inprint::Models::Tag::getById($c, $headline->{tag});
            push @fields, "headline";
            push @fields, "headline_shortcut";
            push @data, $tag->{id};
            push @data, $tag->{title};
        }

        if ($headline->{id} && $rubric->{id}) {
            my $tag = Inprint::Models::Tag::getById($c, $rubric->{tag});
            push @fields, "rubric";
            push @fields, "rubric_shortcut";
            push @data, $tag->{id};
            push @data, $tag->{title};
        }

    }

    # Create document
    unless (@errors) {
        my @placeholders; foreach (@data) { push @placeholders, "?"; }

        $c->sql->bt;

        # Crete document
        $c->sql->Do(" INSERT INTO documents (" . ( join ",", @fields ) .") VALUES (". ( join ",", @placeholders ) .") ", \@data);

        # Get new document
        my $document = $c->sql->Q(" SELECT * FROM documents WHERE id=? ", [ $id ])->Hash;
        my $principal = Inprint::Check::principal($c, \@errors, $c->QuerySessionGet("member.id"));

        # Create document comment
        if ($i_comment) {
            Inprint::Models::Documents::say($c,
                $document->{id}, $document->{stage}, $document->{stage_shortcut}, $document->{color},
                $principal->{id}, $principal->{shortcut}, $i_comment
            );
        }

        # Create history
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

    my $i_id        = $c->param("id");
    my $i_title     = $c->param("title");
    my $i_author    = $c->param("author");
    my $i_size      = $c->param("size") || 0;
    my $i_enddate   = $c->param("enddate");

    my $i_maingroup = $c->param("maingroup");
    my $i_manager   = $c->param("manager");

    my $i_headline  = $c->param("headline");
    my $i_rubric    = $c->param("rubric");

    my @errors;
    my $success = $c->json->false;

    Inprint::Check::uuid($c, \@errors, "id", $i_id);
    Inprint::Check::text($c, \@errors, "title", $i_title);

    Inprint::Check::text($c, \@errors, "author", $i_author) if ($i_author);
    Inprint::Check::int($c, \@errors, "size", $i_size) if ($i_size);
    Inprint::Check::date($c, \@errors, "enddate", $i_enddate) if ($i_enddate);

    my $document = Inprint::Check::document($c, \@errors, $i_id);

    # Rubrication
    my $headline; unless ( @errors ) {
        if ($i_headline) {
            $headline = $c->sql->Q("
                SELECT * FROM fascicles_indx_headlines WHERE fascicle=? AND tag=? ",
                [ $document->{fascicle}, $i_headline ])->Hash;
            push @errors, { id => "headline", msg => "Object not found"}
                unless ($headline->{id});
        }
    }

    my $rubric; unless ( @errors ) {
        if ($i_rubric) {
            $rubric = $c->sql->Q("
                SELECT * FROM fascicles_indx_rubrics WHERE fascicle=? AND tag=? ",
                [ $document->{fascicle}, $i_rubric ])->Hash;
            push @errors, { id => "rubric", msg => "Object not found"}
                unless ($rubric->{id});
        }
    }

    my $canAssign = Inprint::Check::access($c, undef, "catalog.documents.assign:*", $document->{workgroup});
    my $maingroup = Inprint::Check::principal($c, \@errors, $i_maingroup) if ($canAssign);
    my $manager   = Inprint::Check::principal($c, \@errors, $i_manager) if ($canAssign);

    # Update assignation
    unless (@errors) {
        if ($canAssign) {
            $c->sql->Do(" UPDATE documents SET maingroup=?, maingroup_shortcut=? WHERE id=? OR copygroup=?; ",
                [ $maingroup->{id}, $maingroup->{shortcut}, $document->{id}, $document->{id} ]);
            $c->sql->Do(" UPDATE documents SET manager=?, manager_shortcut=? WHERE id=? OR copygroup=?; ",
                [ $manager->{id}, $manager->{shortcut}, $document->{id}, $document->{id} ]);
        }
    }

    unless (@errors) {
        my $canUpdate = Inprint::Check::access($c, undef, "catalog.documents.update:*", $document->{workgroup});
        if ($canUpdate) {

            # Update workgroup
            $c->sql->Do(" UPDATE documents SET title=?, author=?, psize=?, pdate=? WHERE id=? OR copygroup=?; ",
                [ $i_title, $i_author, $i_size, $i_enddate, $document->{id}, $document->{id} ]);

            # Update headline and rubric
            if ($headline->{id}) {
                my $tag = Inprint::Models::Tag::getById($c, $headline->{tag});
                $c->sql->Do(" UPDATE documents SET headline=?, headline_shortcut=? WHERE id=? ", [ $tag->{id}, $tag->{title}, $document->{id} ]);
            } else {
                $c->sql->Do(" UPDATE documents SET headline=null, headline_shortcut=null WHERE id=? ", [ $document->{id} ]);
            }

            if ($headline->{id} && $rubric->{id}) {
                my $tag = Inprint::Models::Tag::getById($c, $rubric->{tag});
                $c->sql->Do(" UPDATE documents SET rubric=?, rubric_shortcut=? WHERE id=? ", [ $tag->{id}, $tag->{title}, $document->{id} ]);
            } else {
                $c->sql->Do(" UPDATE documents SET rubric=null, rubric_shortcut=null WHERE id=? ", [ $document->{id} ]);
            }

        }

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
                    readiness=?, readiness_shortcut=?, color=?, progress=?,
                    islooked = false,
                    moved=now()
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
    push @errors, { id => "fascicle", msg => "Incorrectly filled field"}
        unless ($fascicle->{id});

    unless (@errors) {
        foreach my $id (@ids) {
            $c->sql->bt;

            my $document = $c->sql->Q(" SELECT * FROM documents WHERE id=? ", [ $id ])->Hash;

            next unless ($document->{id});

            $c->sql->Do(" DELETE FROM fascicles_map_documents WHERE fascicle=? AND entity=? ", [ $document->{fascicle}, $document->{id} ]);
            $c->sql->Do(" UPDATE documents SET fascicle=?, fascicle_shortcut=? WHERE id=? ", [ $fascicle->{id}, $fascicle->{shortcut}, $document->{id} ]);

            $c->reindex($document->{id}, $document->{edition}, $fascicle->{id}, $document->{headline}, $document->{rubric});

            $c->sql->et;
        }
    }

    $success = $c->json->true unless (@errors);
    $c->render_json( { success => $success, errors => \@errors } );
}

sub move {
    my $c = shift;

    my @ids = $c->param("id");

    my $i_fascicle = $c->param("fascicle");
    my $i_headline = $c->param("headline");
    my $i_rubric   = $c->param("rubric");
    my $i_change   = $c->param("ch-rub");

    my @errors;
    my $success = $c->json->false;

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

            # Update indexation
            if ($i_change eq "yes") {
                $c->reindex($document->{id}, $edition->{id}, $fascicle->{id}, $i_headline, $i_rubric);
            }
            #else {
            #    $c->reindex($document->{id}, $edition->{id}, $fascicle->{id}, $document->{headline}, $document->{rubric});
            #}

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
                            maingroup, maingroup_shortcut,
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
                            ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,
                            ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, now(), now()
                        );
                    ", [
                        $new_id,
                            $document->{creator}, $document->{creator_shortcut},
                            $document->{holder},  $document->{holder_shortcut},
                            $document->{manager}, $document->{manager_shortcut},
                            $document->{edition}, $document->{edition_shortcut},  $document->{ineditions},
                            $document->{copygroup},
                            $document->{maingroup}, $document->{maingroup_shortcut},
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

                    # Change Index
                    #if ($headline->{id}) {
                        $c->reindex($document->{id}, $edition->{id}, $fascicle->{id}, $headline_id, $rubric_id);
                    #} else {
                    #    $c->reindex($document->{id}, $edition->{id}, $fascicle->{id}, $document->{headline}, $document->{rubric});
                    #}

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

        #my $headline = Inprint::Utils::GetHeadlineById($c, id => $headline_id);
        #my $rubric   = Inprint::Utils::GetRubricById($c,   id => $rubric_id);

        foreach my $document_id (@ids) {

            my $document = $c->sql->Q("SELECT * FROM documents WHERE id=?", [ $document_id ])->Hash;

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
                        maingroup, maingroup_shortcut,
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
                        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,
                        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, now(), now()
                    );
                ", [
                    $new_id,
                        $document->{creator}, $document->{creator_shortcut},
                        $document->{holder},  $document->{holder_shortcut},
                        $document->{manager}, $document->{manager_shortcut},
                        $document->{edition}, $document->{edition_shortcut},  $document->{ineditions},
                        $new_id, $document->{movegroup} || $new_id,
                        $document->{maingroup}, $document->{maingroup_shortcut},
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

                # Indexation
                #if ($headline->{id}) {
                    $c->reindex($document->{id}, $edition->{id}, $fascicle->{id}, $headline_id, $rubric_id);
                #} else {
                #    $c->reindex($document->{id}, $edition->{id}, $fascicle->{id}, $document->{headline}, $document->{rubric});
                #}

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

    Inprint::Check::uuid($c, \@errors, "id", $i_id);
    Inprint::Check::text($c, \@errors, "text", $i_text);

    my $document  = Inprint::Check::document($c, \@errors, $i_id);
    my $principal = Inprint::Check::principal($c, \@errors, $c->QuerySessionGet("member.id"));

    unless (@errors) {
        Inprint::Models::Documents::say($c,
            $document->{id}, $document->{stage}, $document->{stage_shortcut}, $document->{color},
            $principal->{id}, $principal->{shortcut}, $i_text
        );
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
                        $c->reindex($document->{id}, $document->{edition}, $fascicle->{id}, $document->{headline}, $document->{rubric});

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
                        $c->reindex($document->{id}, $document->{edition}, $fascicle->{id}, $document->{headline}, $document->{rubric});
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


################################################################################

sub reindex {

    my $c = shift;

    my $document = shift; # document id
    my $edition  = shift; # new edition
    my $fascicle = shift; # new fascicle
    my $headline = shift; # new document headline
    my $rubric   = shift; # new document rubric

    my $new_headline;
    if ($headline) {

        my $old_headline = $c->sql->Q("
            SELECT t1.id, t1.edition, t1.fascicle,
                t2.id as tag, t2.title, t2.description
            FROM fascicles_indx_headlines t1, indx_tags t2
            WHERE t1.tag=t2.id AND t1.tag=? ",
            [ $headline ])->Hash;

        if ($old_headline->{id}) {

            $new_headline = $c->sql->Q("
                SELECT * FROM fascicles_indx_headlines WHERE fascicle=? AND tag=?",
                [ $fascicle, $old_headline->{tag} ])->Hash;

            unless ($new_headline) {
                Inprint::Models::Fascicle::Headline::create($c,
                    $c->uuid, $edition, $fascicle, undef,
                    $old_headline->{title}, $old_headline->{description});
                $new_headline = $c->sql->Q("
                    SELECT * FROM fascicles_indx_headlines WHERE fascicle=? AND tag=?",
                    [ $fascicle, $old_headline->{tag} ])->Hash;
            }
        }

    }

    my $new_rubric;
    if ($new_headline->{id} && $rubric) {

        my $old_rubric = $c->sql->Q("
            SELECT t1.id, t1.edition, t1.fascicle,
                t2.id as tag, t2.title, t2.description
            FROM fascicles_indx_rubrics t1, indx_tags t2
            WHERE t1.tag=t2.id AND t1.tag=? ",
            [ $rubric ])->Hash;

        if ($old_rubric->{id}) {

            $new_rubric = $c->sql->Q("
                SELECT * FROM fascicles_indx_rubrics
                WHERE fascicle=? AND headline=? AND tag=?",
                [ $fascicle, $new_headline->{id}, $old_rubric->{tag} ])->Hash;

            unless ($new_rubric) {
                Inprint::Models::Fascicle::Rubric::create($c,
                    $c->uuid, $edition, $fascicle, $new_headline->{id}, undef,
                    $old_rubric->{title}, $old_rubric->{description});
                $new_rubric = $c->sql->Q("
                    SELECT * FROM fascicles_indx_rubrics
                    WHERE fascicle=? AND headline=? AND tag=?",
                    [ $fascicle, $new_headline->{id}, $old_rubric->{tag} ])->Hash;
            }
        }
    }

    # update

    if ($new_headline->{id}) {
        my $tag = Inprint::Models::Tag::getById($c, $new_headline->{tag});
        $c->sql->Do(" UPDATE documents SET headline=?, headline_shortcut=? WHERE id=? ", [ $tag->{id}, $tag->{title}, $document ]);
    }

    if ($new_rubric->{id}) {
        my $tag = Inprint::Models::Tag::getById($c, $new_rubric->{tag});
        $c->sql->Do(" UPDATE documents SET rubric=?, rubric_shortcut=? WHERE id=? ", [ $tag->{id}, $tag->{title}, $document ]);
    }


}


1;
