package Inprint::Calendar::CopyAttachment;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use Inprint::Models::Attachment;
use Inprint::Models::Documents;

sub copy {

    my $c      = shift;
    my $attachment_id = shift;
    my $issue_id  = shift;

    my @errors;
    my %cache;

    my $attachment = $c->Q("
        SELECT * FROM fascicles WHERE id=?;
        ", [ $attachment_id ])->Hash;

    return unless ($attachment->{id});

    my $issue = $c->Q("
        SELECT * FROM fascicles WHERE id=?;
        ", [ $issue_id ])->Hash;

    return unless ($issue->{id});

    #return if ( $attachment->{edition} ne $issue->{edition});

    my $exists = $c->Q("
        SELECT id FROM fascicles WHERE edition=? AND parent=? ",
        [ $attachment->{edition}, $issue->{id} ])->Value;

    #return if $exists;

    # Create attachment

    $c->txBegin;

    my $attachment_new = $c->uuid;
    my $edition_new = $attachment->{edition};

    Inprint::Models::Attachment::create(
        $c, $attachment_new,
        $attachment->{edition}, $issue->{id},
        $attachment->{shortcut}, $attachment->{description},
        $attachment->{template}, $attachment->{template_shortcut},
        $attachment->{circulation}, $attachment->{num}, $attachment->{anum},
        $attachment->{doc_date}, $attachment->{adv_date},
        $attachment->{print_date}, $attachment->{release_date}
    );

    # Import Headlines && Rubrics
    my $headlines = $c->Q("
        SELECT id, tag, bydefault, title, description
        FROM fascicles_indx_headlines
        WHERE fascicle = ? ",
        [ $attachment->{id} ])->Hashes;

    foreach my $headline (@$headlines) {

        my $headline_id = $c->uuid();
        $cache{ $headline->{id} } = $headline_id;

        $c->Do("
            INSERT INTO
                fascicles_indx_headlines
                    (
                        id, edition, fascicle,
                        tag, bydefault,
                        title, description,
                        created, updated)
            VALUES
                    (?, ?, ?, ?, ?, ?, ?, now(), now()); ",
            [
                $headline_id, $edition_new, $attachment_new,
                $headline->{tag}, $headline->{bydefault},
                $headline->{title}, $headline->{description} || "" ]);

        my $rubrics = $c->Q("
            SELECT id, tag, title, description
            FROM fascicles_indx_rubrics WHERE headline=? ",
            [ $headline->{id} ])->Hashes;

        foreach my $rubric (@$rubrics) {
            my $rubric_id = $c->uuid();
            $c->Do("
                INSERT INTO fascicles_indx_rubrics
                    (
                        id, edition, fascicle,
                        tag, headline,
                        title, description,
                        created, updated)
                VALUES (?, ?, ?, ?, ?, ?, ?, now(), now()); ",
                [
                    $rubric_id, $edition_new, $attachment_new,
                    $rubric->{tag}, $headline_id,
                    $rubric->{title}, $rubric->{description} ]);
        }

    }

    # Import templates for pages and modules

    my $tmpl_pages   = $c->Q("
            SELECT id, origin, title, description, bydefault, w, h, created, updated
            FROM fascicles_tmpl_pages
            WHERE fascicle = ? ",
        [ $attachment->{id} ])->Hashes;

    foreach my $page (@$tmpl_pages) {

        my $page_id = $c->uuid;

        $c->Do("
            INSERT INTO
                fascicles_tmpl_pages
                    (
                        id, origin, fascicle,
                        title, description,
                        bydefault, w, h,
                        created, updated)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, now(), now()); ",
            [
                $page_id, $page->{origin}, $attachment_new,
                $page->{title}, $page->{description},
                $page->{bydefault}, $page->{w}, $page->{h} ]);

        my $tmpl_modules = $c->Q("
            SELECT
                    id, origin, page,
                    title, description,
                    amount, area,
                    x, y, w, h,
                    width, height, fwidth, fheight,
                    created, updated
                FROM fascicles_tmpl_modules
                WHERE page=? ",
            [ $page->{id} ])->Hashes;

        foreach my $tmpl_module (@$tmpl_modules) {

            my $module_id = $c->uuid();
            $cache{ $tmpl_module->{id} } = $module_id;

            $c->Do("
                INSERT INTO fascicles_tmpl_modules
                    (
                        id, origin, fascicle, page,
                        title, description,
                        amount, area,
                        x, y, w, h,
                        width, height, fwidth, fheight,
                        created, updated)
                    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, now(), now()); ",
                [
                    $module_id, $tmpl_module->{origin}, $attachment_new, $page_id,
                    $tmpl_module->{title}, $tmpl_module->{description},
                    $tmpl_module->{amount}, $tmpl_module->{area},
                    $tmpl_module->{x}, $tmpl_module->{y}, $tmpl_module->{w}, $tmpl_module->{h},
                    $tmpl_module->{width}, $tmpl_module->{height}, $tmpl_module->{fwidth}, $tmpl_module->{fheight} ]);

        }

    }

    # Import Places

    my $tmpl_places  = $c->Q("
            SELECT id, origin, title, description, created, updated
            FROM fascicles_tmpl_places
            WHERE fascicle = ? ",
        [ $attachment->{id} ])->Hashes;

    foreach my $place (@$tmpl_places) {

        my $place_id = $c->uuid();
        $cache{ $place->{id} } = $place_id;

        $c->Do("
            INSERT INTO fascicles_tmpl_places(id, origin, fascicle, title, description, created, updated)
                VALUES (?, ?, ?, ?, ?, now(), now());
        ", [ $place_id, $place->{origin}, $attachment_new, $place->{title}, $place->{description} ]);

    }

    # Import Index

    my $tmpl_places_index = $c->Q("
            SELECT id, edition, place, nature, entity, created, updated
            FROM fascicles_tmpl_index
            WHERE fascicle = ? ",
        [ $attachment->{id} ])->Hashes;

    foreach my $indx (@$tmpl_places_index) {

        my $indx_id = $c->uuid();

        my $place_id = $cache{ $indx->{place} };
        my $entity_id = $cache{ $indx->{entity} };

        next unless $place_id;
        next unless $entity_id;

        $c->Do("
            INSERT INTO fascicles_tmpl_index(id, edition, fascicle, place, nature, entity, created, updated)
                VALUES (?, ?, ?, ?, ?, ?, now(), now());
        ", [ $indx_id, $attachment->{edition}, $attachment_new, $place_id, $indx->{nature}, $entity_id ]);

    }

    # Import pages
    my $source_pages = $c->Q("
            SELECT id, edition, fascicle, origin, headline, seqnum, w, h
            FROM fascicles_pages
            WHERE fascicle = ? ",
        [ $attachment->{id} ])->Hashes;

    foreach my $page (@$source_pages) {
        my $page_id = $c->uuid();
        my $headline_id = $cache{ $page->{headline} };

        $cache{ $page->{id} } = $page_id;

        $c->Do("
            INSERT INTO fascicles_pages(id, edition, fascicle, origin, headline, seqnum, w, h, created, updated)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, now(), now());
        ", [ $page_id, $attachment->{edition}, $attachment_new, $page->{origin}, $headline_id, $page->{seqnum}, $page->{w}, $page->{h} ]);
    }

    my $source_documents = $c->Q("
            SELECT *
            FROM documents
            WHERE fascicle = ? ",
        [ $attachment->{id} ])->Hashes;

    foreach my $document (@$source_documents) {

        # Copy
        my $copy_fascicle = $c->check_record(\@errors, "fascicles", "fascicle", $attachment_new);
        my $copy_edition  = $c->check_record(\@errors, "editions", "edition", $attachment->{edition});
        my $copy_headline = $c->check_record(\@errors, "indx_tags", "headline", $cache{ $document->{headline} }, 1);
        my $copy_rubric   = $c->check_record(\@errors, "indx_tags", "rubric", $cache{ $document->{rubric} }, 1);

        my $new_id = Inprint::Models::Documents::copy($c, $document, $copy_edition, $copy_fascicle, $copy_headline, $copy_rubric);

        # remap
        my $document_pages = $c->Q("
            SELECT *
            FROM fascicles_map_documents
            WHERE fascicle=? AND entity=? ",
        [ $attachment->{id}, $document->{id} ])->Hashes;

        foreach my $map (@$document_pages) {

            $c->Do("
                INSERT INTO
                    fascicles_map_documents
                        (edition, fascicle, page, entity, created, updated)
                VALUES
                        (?, ?, ?, ?, now(), now()); ",
                [ $attachment->{edition}, $attachment_new, $cache{ $map->{page} }, $new_id ]);

        }

    }

    $c->txCommit;

    return 1;
}


1;
