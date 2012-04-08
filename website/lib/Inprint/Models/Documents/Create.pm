package Inprint::Models::Documents;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

sub create {

    my ($c,

        $id,

        $edition,   $edition_shortcut,
        $fascicle,  $fascicle_shortcut,
        $workgroup, $workgroup_shortcut,
        $manager,   $manager_shortcut,
        $headline,  $headline_shortcut,
        $rubric,    $rubric_shortcut,

        $branch,    $branch_shortcut,
        $stage,     $stage_shortcut,
        $readiness, $readiness_shortcut,

        $color,
        $progress,

        $title, $author, $enddate, $textsize, $comment ) = @_;

    my $sql;
    my @fields;
    my @data;

    push @fields, "id";
    push @data, $id;

    push @fields, "copygroup";
    push @data, $id;

    push @fields, "movegroup";
    push @data, $id;

    push @fields, "title";
    push @data, $title;

    push @fields, "pdate";
    push @data, $enddate;

    push @fields, "psize";
    push @data, $textsize;

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
    if ($author) {
        push @fields, "author";
        push @data, $author;
    }

    # Set Filepath
    my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime(time);

    $year += 1900;
    $mon += 1;

    #my $relativePath = Inprint::Store::Embedded::getRelativePath($c, "documents", "$year-$mon", $id, 1);

    #push @fields, "filepath";
    #push @data, $relativePath;

    my $relativePath = sprintf ("/datastore/documents/%04d-%02d/%s", ((localtime)[5] +1900), ((localtime)[4] +1), $id);
    push @fields, "fs_folder";
    push @data, $relativePath;

    push @fields, "group_id";
    push @data, $c->uuid();

    # Set edition
    push @fields, "edition";
    push @fields, "edition_shortcut";
    push @data, $edition;
    push @data, $edition_shortcut;

    my $editions = $c->Q("
        SELECT ARRAY( select id from editions where path @> ( select path from editions where id = ? ) ) ",
        [ $edition ])->Array;

    push @fields, "ineditions";
    push @data, $editions;

    # Set fascicle
    push @fields, "fascicle";
    push @fields, "fascicle_shortcut";
    push @data, $fascicle;
    push @data, $fascicle_shortcut;

    # Set workgroup
    push @fields, "workgroup";
    push @fields, "workgroup_shortcut";
    push @data, $workgroup;
    push @data, $workgroup_shortcut;

    # Set maingroup
    push @fields, "maingroup";
    push @fields, "maingroup_shortcut";
    push @data, $workgroup;
    push @data, $workgroup_shortcut;

    # Set Inworkgroups[]
    my $workgroups = $c->Q("
        SELECT ARRAY( select id from catalog where path @> ( select path from catalog where id = ? ) ) ",
        [ $workgroup ])->Array;

    push @fields, "inworkgroups";
    push @data, $workgroups;

    # Set creator
    push @fields, "creator";
    push @fields, "creator_shortcut";
    push @data, $c->getSessionValue("member.id");
    push @data, $c->getSessionValue("member.shortcut") || "<Unknown>";

    # Set holder
    push @fields, "manager";
    push @data, $manager;

    push @fields, "manager_shortcut";
    push @data, $manager_shortcut;

    push @fields, "holder";
    push @data, $manager;

    push @fields, "holder_shortcut";
    push @data, $manager_shortcut;

    # Set indexation
    if ($headline) {
        push @fields, "headline";
        push @fields, "headline_shortcut";
        push @data, $headline;
        push @data, $headline_shortcut;
    }

    if ($headline && $rubric) {
        push @fields, "rubric";
        push @fields, "rubric_shortcut";
        push @data, $rubric;
        push @data, $rubric_shortcut;
    }

    # Set Branch
    push @fields, "branch";
    push @fields, "branch_shortcut";
    push @data, $branch;
    push @data, $branch_shortcut;

    # Set Stage
    push @fields, "stage";
    push @fields, "stage_shortcut";
    push @data, $stage;
    push @data, $stage_shortcut;

    # Set Readiness
    push @fields, "readiness";
    push @fields, "readiness_shortcut";
    push @data, $readiness;
    push @data, $readiness_shortcut;

    # Set Color
    push @fields, "color";
    push @data, $color;

    # Set Progress
    push @fields, "progress";
    push @data, $progress;

    # Create document
    my @placeholders; foreach (@data) { push @placeholders, "?"; }

    my $document;

    $c->sql->bt;

    # Crete document
    $c->Do(" INSERT INTO documents (" . ( join ",", @fields ) .") VALUES (". ( join ",", @placeholders ) .") ", \@data);

    # Get new document
    $document = $c->Q(" SELECT * FROM documents WHERE id=? ", [ $id ])->Hash;

    # Create document comment
    if ($comment) {
        $c->Do("
            INSERT INTO comments(
                path, entity, member, member_shortcut, stage, stage_shortcut, stage_color, fulltext, created, updated)
            VALUES (null, ?, ?, ?, ?, ?, ?, ?, now(), now() ) ", [
                $document->{id},
                $c->getSessionValue("member.id"),
                $c->getSessionValue("member.shortcut"), $document->{stage}, $document->{stage_shortcut}, $document->{color},
                $comment
        ]);
    }

    # Create history
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
        $document->{id},        "create",
        $document->{color},     $document->{progress},
        $document->{branch},    $document->{branch_shortcut},
        $document->{stage},     $document->{stage_shortcut},
        $document->{creator},   $document->{creator_shortcut},
        $document->{workgroup}, $document->{workgroup_shortcut},
        $document->{creator},   $document->{creator_shortcut},
        $document->{workgroup}, $document->{workgroup_shortcut},
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
        $document->{id},        "transfer",
        $document->{color},     $document->{progress},
        $document->{branch},    $document->{branch_shortcut},
        $document->{stage},     $document->{stage_shortcut},

        $document->{creator},   $document->{creator_shortcut},
        $document->{workgroup}, $document->{workgroup_shortcut},

        $document->{manager},   $document->{manager_shortcut},
        $document->{workgroup}, $document->{workgroup_shortcut},
    ]);

    $c->sql->et;

    return $document;
}

1;
