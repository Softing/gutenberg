package Inprint::Controllers::Documents;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use Inprint::Models::Documents;

use Inprint::Models::Fascicle::Index;
use Inprint::Models::Fascicle::Headline;
use Inprint::Models::Fascicle::Rubric;

use Inprint::Store::Embedded;
#use Inprint::Store::Cache;

use base 'Mojolicious::Controller';

# Read document
sub read {

    my $c = shift;

    my @errors;
    my $i_id = $c->get_uuid(\@errors, "id");

    my $result;
    unless (@errors) {
        $result = Inprint::Models::Documents::read($c, $i_id);
    }

    $c->smart_render(\@errors, $result);
}

# Get documents list

sub array {
    my ($c, $params) = @_;

    my $searchResult = Inprint::Models::Documents::search($c, $params);

    my $total = $searchResult->{total};
    my $records = $searchResult->{result};

    my @columns = (
        'id',
        'access',
        'edition',
        'edition_shortcut',
        'fascicle',
        'fascicle_shortcut',
        'headline',
        'headline_shortcut',
        'rubric',
        'rubric_shortcut',
        'copygroup',
        'holder',
        'creator',
        'manager',
        'holder_shortcut',
        'creator_shortcut',
        'manager_shortcut',
        'maingroup',
        'maingroup_shortcut',
        'workgroup',
        'workgroup_shortcut',
        'ingroups',
        'islooked',
        'isopen',
        'branch',
        'branch_shortcut',
        'stage',
        'stage_shortcut',
        'color',
        'progress',
        'title',
        'author',
        'pages',
        'pdate',
        'psize',
        'rdate',
        'rsize',
        'images',
        'files',
        'links',
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

    my $result = Inprint::Models::Documents::search($c, $params);

    my $total = $result->{total};
    my $records = $result->{result};

    $c->render_json( { "data" => $records, "total" => $total } );
}

sub create {
    my $c = shift;

    my @errors;

    my $id = my $copyid = $c->uuid();

    my $current_member = $c->getSessionValue("member.id");

    # Get variables

    my $i_title      = $c->get_text(\@errors, "title");

    my $i_edition    = $c->get_uuid(\@errors, "edition");
    my $i_fascicle   = $c->get_uuid(\@errors, "fascicle") // "00000000-0000-0000-0000-000000000000";

    my $i_workgroup  = $c->get_uuid(\@errors, "workgroup");
    my $i_manager    = $c->get_uuid(\@errors, "manager");
    my $i_enddate    = $c->get_date(\@errors, "enddate");

    my $i_headline   = $c->get_uuid(\@errors, "headline", 1);
    my $i_rubric     = $c->get_uuid(\@errors, "rubric", 1);

    my $i_author     = $c->get_text(\@errors, "author", 1);
    my $i_textsize   = $c->get_int(\@errors,  "size", 1) // 0;
    my $i_comment    = $c->get_text(\@errors, "comment", 1);

    # get records
    my $edition   = $c->check_record(\@errors, "editions", "edition", $i_edition);
    my $fascicle  = $c->check_record(\@errors, "fascicles", "fascicle", $i_fascicle);

    my $manager     = $c->check_record(\@errors, "view_principals", "principal", $i_manager, 1);
    my $workgroup   = $c->check_record(\@errors, "view_principals", "principal", $i_workgroup, 1);

    my $headline    = $c->check_record(\@errors, "indx_tags", "headline", $i_headline, 1);
    my $rubric      = $c->check_record(\@errors, "indx_tags", "rubric", $i_rubric, 1);

    return $c->smart_render( \@errors ) if @errors;

    # Check indexation
    if ($headline) {

        my $headline_exists = $c->Q("
            SELECT count(*)
            FROM fascicles_indx_headlines
            WHERE fascicle=? AND tag=?", [ $fascicle->{id}, $headline->{id} ])->Value;

        unless ($headline_exists) {

            if ($fascicle->{id} eq "00000000-0000-0000-0000-000000000000") {
                $c->Do("
                    INSERT INTO fascicles_indx_headlines (edition, fascicle, tag, title, description, created, updated)
                        VALUES (?, ?, ?, ?, ?, ?, now(), now());
                    ", [ $edition->{id}, $fascicle->{id}, $headline->{id}, $headline->{title}, $headline->{description} || "" ]);
            }

            $headline_exists = $c->Q("
                SELECT count(*)
                FROM fascicles_indx_headlines
                WHERE fascicle=? AND tag=?", [ $fascicle->{id}, $headline->{id} ])->Value;
        }

        push @errors, { id => "headline", msg => "Object not found"}
            unless ($headline_exists);
    }
    if ($headline && $rubric) {

        my $rubric_exists = $c->Q("
            SELECT count(*)
            FROM fascicles_indx_rubrics
            WHERE fascicle=? AND tag=?", [ $fascicle->{id}, $rubric->{id} ])->Value;

        unless ($rubric_exists) {

            if ($fascicle->{id} eq "00000000-0000-0000-0000-000000000000") {
                $c->Do("
                    INSERT INTO fascicles_indx_rubrics (edition, fascicle, headline, tag, title, description, created, updated)
                        VALUES (?, ?, ?, ?, ?, ?, now(), now());
                    ", [ $edition->{id}, $fascicle->{id}, $headline->{id}, $rubric->{id}, $rubric->{title}, $rubric->{description} || "" ]);
            }

            $rubric_exists = $c->Q("
                SELECT count(*)
                FROM fascicles_indx_rubrics
                WHERE fascicle=? AND tag=?", [ $fascicle->{id}, $rubric->{id} ])->Value;
        }

        push @errors, { id => "rubric", msg => "Object not found"}
            unless ($rubric_exists);
    }

    # Check user access to this function
    if ( $workgroup ) {
        $c->check_access( \@errors, "catalog.documents.create:*", $workgroup->{id} );
    }
    if ( $fascicle && $fascicle->{id} ne "00000000-0000-0000-0000-000000000000") {
        $c->check_access( \@errors, "editions.documents.assign:*", $edition->{id} );
    }
    if ($current_member ne $manager->{id}) {
        $c->check_access( \@errors, "catalog.documents.assign:*",  $workgroup->{id} );
    }

    return $c->smart_render( \@errors ) if @errors;

    # Check exchange
    my $parents = $c->Q(" SELECT id FROM editions WHERE path @> ?", [ $edition->{path} ])->Values;

    my $stage = $c->Q("
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

    return $c->smart_render( \@errors ) if @errors;

    # Create document
    Inprint::Models::Documents::create($c,

        $id,

        $edition->{id},      $edition->{shortcut},
        $fascicle->{id},     $fascicle->{shortcut},
        $workgroup->{id},    $workgroup->{shortcut},
        $manager->{id},      $manager->{shortcut},

        $headline->{id},     $headline->{title},
        $rubric->{id},       $rubric->{title},

        $stage->{branch},    $stage->{branch_shortcut},
        $stage->{stage},     $stage->{stage_shortcut},
        $stage->{readiness}, $stage->{readiness_shortcut},

        $stage->{color},
        $stage->{progress},

        $i_title, $i_author, $i_enddate, $i_textsize, $i_comment);

    $c->smart_render( \@errors );
}

sub update {

    my $c = shift;

    my @errors;

    my $i_id        = $c->get_uuid(\@errors, "id");
    my $i_title     = $c->get_text(\@errors, "title");
    my $i_author    = $c->get_text(\@errors, "author", 1) // "";
    my $i_size      = $c->get_int(\@errors,  "size", 1) // 0;
    my $i_enddate   = $c->get_date(\@errors, "enddate", 1);

    my $i_maingroup = $c->get_uuid(\@errors, "maingroup", 1);
    my $i_manager   = $c->get_uuid(\@errors, "manager", 1);

    my $i_headline  = $c->get_uuid(\@errors, "headline", 1);
    my $i_rubric    = $c->get_uuid(\@errors, "rubric", 1);

    my $headline    = $c->check_record(\@errors, "indx_tags", "headline", $i_headline, 1);
    my $rubric      = $c->check_record(\@errors, "indx_tags", "rubric", $i_rubric, 1);

    my $manager     = $c->check_record(\@errors, "view_principals", "principal", $i_manager, 1);
    my $maingroup   = $c->check_record(\@errors, "view_principals", "principal", $i_maingroup, 1);

    my $document    = $c->check_record(\@errors, "documents", "document", $i_id);

    return $c->smart_render( \@errors ) if @errors;

    my $edition     = $c->check_record(\@errors, "editions", "edition", $document->{edition});
    my $fascicle    = $c->check_record(\@errors, "fascicles", "fascicle", $document->{fascicle});

    my $canUpdate   = $c->check_access( \@errors, "catalog.documents.update:*", $document->{workgroup});
    my $canAssign   = $c->check_access( undef, "catalog.documents.assign:*", $document->{workgroup});

    return $c->smart_render( \@errors ) if @errors;

    # Check indexation
    if ($headline) {

        my $headline_exists = $c->Q("
            SELECT count(*)
            FROM fascicles_indx_headlines
            WHERE fascicle=? AND tag=?", [ $fascicle->{id}, $headline->{id} ])->Value;

        unless ($headline_exists) {

            if ($fascicle->{id} eq "00000000-0000-0000-0000-000000000000") {
                $c->Do("
                    INSERT INTO fascicles_indx_headlines (edition, fascicle, tag, title, description, created, updated)
                        VALUES (?, ?, ?, ?, ?, ?, now(), now());
                    ", [ $edition->{id}, $fascicle->{id}, $headline->{id}, $headline->{title}, $headline->{description} || "" ]);
            }

            $headline_exists = $c->Q("
                SELECT count(*)
                FROM fascicles_indx_headlines
                WHERE fascicle=? AND tag=?", [ $fascicle->{id}, $headline->{id} ])->Value;
        }

        push @errors, { id => "headline", msg => "Object not found"}
            unless ($headline_exists);
    }

    if ($headline && $rubric) {

        my $rubric_exists = $c->Q("
            SELECT count(*)
            FROM fascicles_indx_rubrics
            WHERE fascicle=? AND tag=?", [ $fascicle->{id}, $rubric->{id} ])->Value;

        unless ($rubric_exists) {

            if ($fascicle->{id} eq "00000000-0000-0000-0000-000000000000") {
                $c->Do("
                    INSERT INTO fascicles_indx_rubrics (edition, fascicle, headline, tag, title, description, created, updated)
                        VALUES (?, ?, ?, ?, ?, ?, now(), now());
                    ", [ $edition->{id}, $fascicle->{id}, $headline->{id}, $rubric->{id}, $rubric->{title}, $rubric->{description} || "" ]);
            }

            $rubric_exists = $c->Q("
                SELECT count(*)
                FROM fascicles_indx_rubrics
                WHERE fascicle=? AND tag=?", [ $fascicle->{id}, $rubric->{id} ])->Value;
        }

        push @errors, { id => "headline", msg => "Object not found"}
            unless ($rubric_exists);
    }

    return $c->smart_render( \@errors ) if @errors;

    # Update document

    Inprint::Models::Documents::update_record($c, $document->{id}, $i_title, $i_author, $i_size, $i_enddate);

    if ($i_headline || ($i_headline && $i_rubric)) {
        Inprint::Models::Documents::update_index(
            $c,
            $document->{id},
            $headline->{id}, $headline->{title},
            $rubric->{id}, $rubric->{title});
    }

    if ($canAssign && $manager) {
        Inprint::Models::Documents::update_manager($c, $document->{id}, $manager->{id}, $manager->{shortcut});
    }

    if ($canAssign && $maingroup) {
        Inprint::Models::Documents::update_maingroup($c, $document->{id}, $maingroup->{id}, $maingroup->{shortcut});
    }

    $c->smart_render(\@errors);
}

sub capture {
    my $c = shift;

    my @errors;
    my @ids = $c->param("id");

    foreach (@ids) {
        $c->check_uuid(\@errors, "id", $_);
    }

    $c->smart_render(\@errors) if @errors;

    my @documents;
    foreach (@ids) {
        my $document = $c->check_record(\@errors, "documents", "document", $_);
        push @documents, $document;
    }

    $c->smart_render(\@errors) if @errors;

    my $edition   = $c->check_record(\@errors, "editions", "edition", $c->getSessionValue("options.default.edition"));
    my $member    = $c->check_record(\@errors, "view_principals", "member", $c->getSessionValue("member.id"));
    my $workgroup = $c->check_record(\@errors, "view_principals", "workgroup ", $c->getSessionValue("options.default.workgroup"));

    $c->smart_render(\@errors) if @errors;

    $c->sql->bt;
    foreach my $document (@documents) {
        Inprint::Models::Documents::capture($c, $document, $workgroup, $member);
    }
    $c->sql->et;

    $c->smart_render( \@errors );
}

sub transfer {
    my $c = shift;

    my @errors;

    my @ids = $c->param("id");
    my $transfer = $c->get_uuid(\@errors, "transfer");

    foreach (@ids) {
        $c->check_uuid(\@errors, "id", $_);
    }

    $c->smart_render(\@errors) if @errors;

    my @documents;
    foreach (@ids) {
        my $document = $c->check_record(\@errors, "documents", "document", $_);
        push @documents, $document;
    }

    $c->smart_render(\@errors) if @errors;

    # Check sender
    my $sender    = $c->check_record(\@errors, "view_principals", "member", $c->getSessionValue("member.id"));

    $c->smart_render(\@errors) if @errors;

    # Check assigment
    my $assignment    = $c->check_record(\@errors, "view_assignments", "assignments", $transfer);

    $c->smart_render(\@errors) if @errors;

    $c->sql->bt;
    foreach my $document (@documents) {
        Inprint::Models::Documents::transfer($c, $document, $assignment, $sender);
    }
    $c->sql->et;

    $c->smart_render( \@errors );
}

sub briefcase {
    my $c = shift;

    my @errors;

    my @ids = $c->param("id");

    my $fascicle = $c->check_record(\@errors, "fascicles", "fascicle", "00000000-0000-0000-0000-000000000000");

    foreach (@ids) {
        $c->check_uuid(\@errors, "id", $_);
    }

    $c->smart_render(\@errors) if @errors;

    my @documents;
    foreach (@ids) {
        my $document = $c->check_record(\@errors, "documents", "document", $_);
        push @documents, $document;
    }

    $c->smart_render(\@errors) if @errors;

    $c->sql->bt;
    foreach my $document (@documents) {
        Inprint::Models::Documents::briefcase($c, $document, $fascicle);
    }
    $c->sql->et;

    $c->smart_render( \@errors );
}

sub move {
    my $c = shift;

    my @errors;

    my @ids = $c->param("id");

    my $i_fascicle = $c->get_uuid(\@errors, "fascicle");
    my $i_headline = $c->get_uuid(\@errors, "headline", 1);
    my $i_rubric   = $c->get_uuid(\@errors, "rubric", 1);

    $c->smart_render(\@errors) if @errors;

    foreach (@ids) {
        $c->check_uuid(\@errors, "id", $_);
    }

    $c->smart_render(\@errors) if @errors;

    my @documents;
    foreach (@ids) {
        my $document = $c->check_record(\@errors, "documents", "document", $_);
        push @documents, $document;
    }

    $c->smart_render(\@errors) if @errors;

    my $fascicle = $c->check_record(\@errors, "fascicles", "fascicle", $i_fascicle);
    my $edition  = $c->check_record(\@errors, "editions", "edition", $fascicle->{edition});

    $c->smart_render(\@errors) if @errors;

    $c->sql->bt;
    foreach my $document (@documents) {
        Inprint::Models::Documents::move($c, $document, $edition, $fascicle, $i_headline, $i_rubric);
    }
    $c->sql->et;

    $c->smart_render(\@errors);
}

sub copy {
    my $c = shift;

    my @errors;

    my @ids = $c->param("id");
    my @copyid = $c->param("copyto");

    foreach (@ids) {
        $c->check_uuid(\@errors, "id", $_);
    }
    $c->smart_render(\@errors) if @errors;

    my @copyes;
    foreach my $copyid (@copyid) {
        my ($fascicle_id, $headline_id, $rubric_id) = split '::', $copyid;

        my $fascicle = $c->check_record(\@errors, "fascicles", "fascicle", $fascicle_id);
        my $edition  = $c->check_record(\@errors, "editions", "edition", $fascicle->{edition});

        my $headline = $c->check_record(\@errors, "indx_tags", "headline", $headline_id, 1);
        my $rubric   = $c->check_record(\@errors, "indx_tags", "rubric", $rubric_id, 1);

        push @copyes, { edition => $edition, fascicle => $fascicle, headline => $headline, rubric => $rubric };
    }
    $c->smart_render(\@errors) if @errors;

    my @documents;
    foreach (@ids) {
        my $document = $c->check_record(\@errors, "documents", "document", $_);
        push @documents, $document;
    }
    $c->smart_render(\@errors) if @errors;

    $c->sql->bt();
    foreach my $item (@copyes) {

        my $fascicle = $item->{fascicle};
        my $edition  = $item->{edition};
        my $headline = $item->{headline};
        my $rubric   = $item->{rubric};

        foreach my $document (@documents) {
            Inprint::Models::Documents::copy($c, $document, $edition, $fascicle, $headline, $rubric);
        }

    }
    $c->sql->et();

    $c->smart_render( \@errors );
}

sub duplicate {

    my $c = shift;

    my @errors;

    my @ids = $c->param("id");
    my @copyid = $c->param("copyto");

    foreach (@ids) {
        $c->check_uuid(\@errors, "id", $_);
    }
    $c->smart_render(\@errors) if @errors;

    my @copyes;
    foreach my $copyid (@copyid) {

        my ($fascicle_id, $headline_id, $rubric_id) = split '::', $copyid;

        my $fascicle = $c->check_record(\@errors, "fascicles", "fascicle", $fascicle_id);
        my $edition  = $c->check_record(\@errors, "editions", "edition", $fascicle->{edition});

        my $headline = {};
        if ($headline_id) {
            $headline = $c->check_record(\@errors, "indx_tags", "headline", $headline_id);
        }
        my $rubric = {};
        if ($rubric_id) {
            $rubric = $c->check_record(\@errors, "indx_tags", "rubric", $rubric_id);
        }

        push @copyes, { edition => $edition, fascicle => $fascicle, headline => $headline, rubric => $rubric };

    }
    $c->smart_render(\@errors) if @errors;

    my @documents;
    foreach (@ids) {
        my $document = $c->check_record(\@errors, "documents", "document", $_);
        push @documents, $document;
    }
    $c->smart_render(\@errors) if @errors;

    $c->sql->bt();
    foreach my $item (@copyes) {

        my $fascicle = $item->{fascicle};
        my $edition  = $item->{edition};
        my $headline = $item->{headline};
        my $rubric   = $item->{rubric};

        foreach my $document (@documents) {
            Inprint::Models::Documents::duplicate($c, $document, $edition, $fascicle, $headline, $rubric);
        }

    }
    $c->sql->et();

    $c->smart_render( \@errors );
}

sub recycle {
    my $c = shift;

    my @errors;

    my @ids = $c->param("id");

    foreach (@ids) {
        $c->check_uuid(\@errors, "id", $_);
    }
    $c->smart_render(\@errors) if @errors;

    my @documents;
    foreach (@ids) {
        my $document = $c->check_record(\@errors, "documents", "document", $_);
        push @documents, $document;
    }
    $c->smart_render(\@errors) if @errors;

    foreach my $document (@documents) {
        $c->check_access( \@errors, "catalog.documents.delete:*", $document->{workgroup});
    }
    $c->smart_render(\@errors) if @errors;

    my $fascicle = $c->check_record(\@errors, "fascicles", "fascicle", "99999999-9999-9999-9999-999999999999");
    $c->smart_render(\@errors) if @errors;

    $c->sql->bt();
    foreach my $document (@documents) {
        Inprint::Models::Documents::recycle($c, $document, $fascicle);
    }
    $c->sql->et();

    $c->smart_render( \@errors );
}

sub restore {
    my $c = shift;

    my @errors;

    my @ids = $c->param("id");

    foreach (@ids) {
        $c->check_uuid(\@errors, "id", $_);
    }
    $c->smart_render(\@errors) if @errors;

    my @documents;
    foreach (@ids) {
        my $document = $c->check_record(\@errors, "documents", "document", $_);
        push @documents, $document;
    }
    $c->smart_render(\@errors) if @errors;

    foreach my $document (@documents) {
        $c->check_access( \@errors, "catalog.documents.delete:*", $document->{workgroup});
    }
    $c->smart_render(\@errors) if @errors;

    my $fascicle = $c->check_record(\@errors, "fascicles", "fascicle", "00000000-0000-0000-0000-000000000000");
    $c->smart_render(\@errors) if @errors;

    $c->sql->bt();
    foreach my $document (@documents) {
        Inprint::Models::Documents::restore($c, $document, $fascicle);
    }
    $c->sql->et();

    $c->smart_render( \@errors );
}

sub delete {
    my $c = shift;

    my @errors;

    my @ids = $c->param("id");

    foreach (@ids) {
        $c->check_uuid(\@errors, "id", $_);
    }
    $c->smart_render(\@errors) if @errors;

    my @documents;
    foreach (@ids) {
        my $document = $c->check_record(\@errors, "documents", "document", $_);
        push @documents, $document;
    }
    $c->smart_render(\@errors) if @errors;

    foreach my $document (@documents) {
        $c->check_access( \@errors, "catalog.documents.delete:*", $document->{workgroup});
    }
    $c->smart_render(\@errors) if @errors;

    $c->sql->bt();
    foreach my $document (@documents) {
        Inprint::Models::Documents::delete($c, $document);
    }
    $c->sql->et();

    $c->smart_render( \@errors );
}

1;
