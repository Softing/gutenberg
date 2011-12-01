package Inprint::Models::Documents;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

sub capture {
    my ($c, $document, $workgroup, $member) = @_;

    $document = $c->get_record("documents", $document)          unless ($document->{id});

    # Move to member
    $member = $c->get_record("view_principals", $member)        unless ($member->{id});
    $c->Do("
        UPDATE documents SET
            holder=?, holder_shortcut=?,
            fdate=now()
        WHERE id=?
    ", [
        $member->{id}, $member->{shortcut},
        $document->{id}
    ]);

    $c->Do("
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
        $document->{workgroup}, $document->{workgroup_shortcut},
    ]);

    # Move to workgroup
    #$workgroup = $c->get_record("view_principals", $workgroup)  unless ($workgroup->{id});
    #my $workgroups = $c->Q("
    #    SELECT ARRAY( select id from catalog where path @> ( select path from catalog where id = ? ) )
    #", [ $workgroup->{id} ])->Array;
    #$c->Do("
    #    UPDATE documents SET
    #        workgroup=?, workgroup_shortcut=?, inworkgroups=?,
    #        fdate=now()
    #    WHERE id=?
    #", [
    #    $workgroup->{id}, $workgroup->{shortcut}, $workgroups,
    #    $document->{id}
    #]);
    #$c->Do("
    #    INSERT INTO history(
    #        entity, operation,
    #        color, weight,
    #        branch, branch_shortcut,
    #        stage, stage_shortcut,
    #        sender, sender_shortcut,
    #        sender_catalog, sender_catalog_shortcut,
    #        destination, destination_shortcut,
    #        destination_catalog, destination_catalog_shortcut,
    #        created)
    #    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, now());
    #", [
    #    $document->{id}, "transfer",
    #    $document->{color}, $document->{progress},
    #    $document->{branch}, $document->{branch_shortcut},
    #    $document->{stage}, $document->{stage_shortcut},
    #    $document->{creator}, $document->{creator_shortcut},
    #    $document->{workgroup}, $document->{workgroup_shortcut},
    #    $document->{holder}, $document->{holder_shortcut},
    #    $workgroup->{id}, $workgroup->{shortcut},
    #]);

    return 1;
}

sub transfer {

    my ($c, $document, $assignment, $sender ) = @_;

    $document   = $c->get_record("documents", $document)          unless ($document->{id});
    $assignment = $c->get_record("view_assignments", $assignment) unless ($assignment->{id});
    $sender     = $c->get_record("view_principals", $sender)      unless ($sender->{id});

    my $workgroups = $c->Q("
        SELECT ARRAY( select id from catalog where path @> ( select path from catalog where id = ? ) )
    ", [ $assignment->{catalog} ])->Array;

    if ($assignment->{principal_type} eq "group") {
        $assignment->{catalog} = $assignment->{principal};
        $assignment->{catalog_shortcut} = $assignment->{principal_shortcut};
    }

    $c->Do("
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
        $document->{id}
    ]);

    $c->Do("
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

    return 1;
}

sub briefcase {
    my ($c, $document, $fascicle ) = @_;

    $document = $c->get_record("documents", $document) unless ($document->{id});
    $fascicle = $c->get_record("fascicles", $fascicle) unless ($fascicle->{id});

    $c->Do("
        DELETE FROM fascicles_map_documents WHERE fascicle=? AND entity=? ",
        [ $document->{fascicle}, $document->{id} ]);

    $c->Do("
        UPDATE documents SET fascicle=?, fascicle_shortcut=? WHERE id=? ",
        [ $fascicle->{id}, $fascicle->{shortcut}, $document->{id} ]);

    __reindex($c, $document->{id}, $document->{edition}, $fascicle->{id}, $document->{headline}, $document->{rubric});

    return 1;
}

sub move {

    my ($c, $document, $edition, $fascicle, $headline, $rubric ) = @_;

    $document = $c->get_record("documents", $document) unless ($document->{id});
    $edition  = $c->get_record("editions",  $edition)  unless ($edition->{id});
    $fascicle = $c->get_record("fascicles", $fascicle) unless ($fascicle->{id});

    #  Remove document from old fascicle composition
    if ($document->{fascicle} ne $fascicle->{id}) {
        $c->Do(" DELETE FROM fascicles_map_documents WHERE fascicle=? AND entity=? ", [ $document->{fascicle}, $document->{id} ]);
    }

    # Change fascicle to new
    $c->Do("
        UPDATE documents SET edition=?,  edition_shortcut=?  WHERE id=? ",
        [ $edition->{id}, $edition->{shortcut}, $document->{id} ]);

    $c->Do("
        UPDATE documents SET fascicle=?, fascicle_shortcut=? WHERE id=? ",
        [ $fascicle->{id}, $fascicle->{shortcut}, $document->{id} ]);

    # Update indexation
    if ($headline || ($headline && $rubric)) {
        __reindex($c, $document->{id}, $edition->{id}, $fascicle->{id}, $headline, $rubric);
    }

    return 1;
}

sub copy {

    my ($c, $document, $edition, $fascicle, $headline, $rubric ) = @_;

    $document = $c->get_record("documents", $document) unless ($document->{id});
    $edition  = $c->get_record("editions",  $edition)  unless ($edition->{id});
    $fascicle = $c->get_record("fascicles", $fascicle) unless ($fascicle->{id});

    my $exist = $c->Q(
        "SELECT true FROM documents WHERE copygroup=? AND fascicle=?",
        [ $document->{id}, $fascicle->{id} ])->Value;

    next if ($exist);

    my $new_id = $c->uuid();

    $c->Do("
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
    my $editions = $c->Q("
        SELECT ARRAY( select id from editions where path @> ( select path from editions where id = ? ) )
    ", [ $edition->{id} ])->Array;
    $c->Do(" UPDATE documents SET edition=?, edition_shortcut=?, ineditions=? WHERE id=? ", [ $edition->{id}, $edition->{shortcut}, $editions, $new_id ]);

    # Change Fascicle
    $c->Do(" UPDATE documents SET fascicle=?, fascicle_shortcut=? WHERE id=? ", [ $fascicle->{id}, $fascicle->{shortcut}, $new_id ]);

    # Change Index
    __reindex($c, $document->{id}, $edition->{id}, $fascicle->{id}, $headline->{id}, $rubric->{id});

    return 1;
}

sub duplicate {

    my ($c, $document, $edition, $fascicle, $headline, $rubric ) = @_;

    $document = $c->get_record("documents", $document) unless ($document->{id});
    $edition  = $c->get_record("editions",  $edition)  unless ($edition->{id});
    $fascicle = $c->get_record("fascicles", $fascicle) unless ($fascicle->{id});

    my $new_id = $c->uuid();

    #filepath
    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
    $year += 1900;
    $mon += 1;
    my $filepath = "/$year/$mon/$new_id";

    $c->Do("
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
    my $editions = $c->Q("
        SELECT ARRAY( select id from editions where path @> ( select path from editions where id = ? ) )
    ", [ $edition->{id} ])->Array;
    $c->Do(" UPDATE documents SET edition=?, edition_shortcut=?, ineditions=? WHERE id=? ", [ $edition->{id}, $edition->{shortcut}, $editions, $new_id ]);

    # Change Fascicle
    $c->Do(" UPDATE documents SET fascicle=?, fascicle_shortcut=? WHERE id=? ", [ $fascicle->{id}, $fascicle->{shortcut}, $new_id ]);

    # Indexation
    __reindex($c, $document->{id}, $edition->{id}, $fascicle->{id}, $headline->{id}, $rubric->{id});

    # Datastore
    my $storePath = $c->config->get("store.path");
    my $old_path  = __FS_ProcessPath($c, "$storePath/documents/$document->{filepath}");
    my $new_path  = __FS_ProcessPath($c, "$storePath/documents/$filepath");

    if (-w $storePath) {
        if (-r $old_path) {
            rcopy($old_path, $new_path) || die "$!";
        }
    }
}

################################################################################

sub __reindex {

    my $c = shift;

    my $document = shift; # document id
    my $edition  = shift; # new edition
    my $fascicle = shift; # new fascicle
    my $headline = shift; # new document headline
    my $rubric   = shift; # new document rubric

    my $new_headline;
    if ($headline) {

        my $old_headline = $c->Q("
            SELECT t1.id, t1.edition, t1.fascicle,
                t2.id as tag, t2.title, t2.description
            FROM fascicles_indx_headlines t1, indx_tags t2
            WHERE t1.tag=t2.id AND t1.tag=? ",
            [ $headline ])->Hash;

        if ($old_headline->{id}) {

            $new_headline = $c->Q("
                SELECT * FROM fascicles_indx_headlines WHERE fascicle=? AND tag=?",
                [ $fascicle, $old_headline->{tag} ])->Hash;

            unless ($new_headline) {
                Inprint::Models::Fascicle::Headline::create($c,
                    $c->uuid, $edition, $fascicle, undef,
                    $old_headline->{title}, $old_headline->{description});
                $new_headline = $c->Q("
                    SELECT * FROM fascicles_indx_headlines WHERE fascicle=? AND tag=?",
                    [ $fascicle, $old_headline->{tag} ])->Hash;
            }
        }

    }

    my $new_rubric;
    if ($new_headline->{id} && $rubric) {

        my $old_rubric = $c->Q("
            SELECT t1.id, t1.edition, t1.fascicle,
                t2.id as tag, t2.title, t2.description
            FROM fascicles_indx_rubrics t1, indx_tags t2
            WHERE t1.tag=t2.id AND t1.tag=? ",
            [ $rubric ])->Hash;

        if ($old_rubric->{id}) {

            $new_rubric = $c->Q("
                SELECT * FROM fascicles_indx_rubrics
                WHERE fascicle=? AND headline=? AND tag=?",
                [ $fascicle, $new_headline->{id}, $old_rubric->{tag} ])->Hash;

            unless ($new_rubric) {
                Inprint::Models::Fascicle::Rubric::create($c,
                    $c->uuid, $edition, $fascicle, $new_headline->{id}, undef,
                    $old_rubric->{title}, $old_rubric->{description});
                $new_rubric = $c->Q("
                    SELECT * FROM fascicles_indx_rubrics
                    WHERE fascicle=? AND headline=? AND tag=?",
                    [ $fascicle, $new_headline->{id}, $old_rubric->{tag} ])->Hash;
            }
        }
    }

    # update

    if ($new_headline->{id}) {
        my $tag = Inprint::Models::Tag::getById($c, $new_headline->{tag});
        $c->Do(" UPDATE documents SET headline=?, headline_shortcut=? WHERE id=? ", [ $tag->{id}, $tag->{title}, $document ]);
    }

    if ($new_rubric->{id}) {
        my $tag = Inprint::Models::Tag::getById($c, $new_rubric->{tag});
        $c->Do(" UPDATE documents SET rubric=?, rubric_shortcut=? WHERE id=? ", [ $tag->{id}, $tag->{title}, $document ]);
    }

    return 1;
}

1;
