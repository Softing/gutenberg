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
    my $source_id = shift;
    my $issue_id  = shift;

    my @errors;
    my %cache;

    my $source = $c->Q("
        SELECT * FROM fascicles WHERE id=?;
        ", [ $source_id ])->Hash;

    return unless ($source->{id});

    my $issue = $c->Q("
        SELECT * FROM fascicles WHERE id=?;
        ", [ $issue_id ])->Hash;

    return unless ($issue->{id});

    my $exists = $c->Q("
        SELECT id FROM fascicles WHERE edition=? AND parent=? ",
        [ $source->{edition}, $issue->{id} ])->Value;

    # Create attachment

    $c->txBegin;

    my $attachment_new = $c->uuid;
    my $edition_new = $source->{edition};

    Inprint::Models::Attachment::create(
        $c, $attachment_new,
        $source->{edition}, $issue->{id},
        $source->{shortcut}, $source->{description},
        $source->{template}, $source->{template_shortcut},
        $source->{circulation}, $source->{num}, $source->{anum},
        $source->{doc_date}, $source->{adv_date},
        $source->{print_date}, $source->{release_date}
    );

    # Import Headlines && Rubrics
    my $headlines = $c->Q("
        SELECT id, tag, bydefault, title, description
        FROM fascicles_indx_headlines
        WHERE fascicle = ? ",
        [ $source->{id} ])->Hashes;

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
        [ $source->{id} ])->Hashes;

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
        [ $source->{id} ])->Hashes;

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
        [ $source->{id} ])->Hashes;

    foreach my $indx (@$tmpl_places_index) {

        my $indx_id = $c->uuid();

        my $place_id = $cache{ $indx->{place} };
        my $entity_id = $cache{ $indx->{entity} };

        next unless $place_id;
        next unless $entity_id;

        $c->Do("
            INSERT INTO fascicles_tmpl_index(id, edition, fascicle, place, nature, entity, created, updated)
                VALUES (?, ?, ?, ?, ?, ?, now(), now());
        ", [ $indx_id, $source->{edition}, $attachment_new, $place_id, $indx->{nature}, $entity_id ]);

    }

    # Import pages
    my $source_pages = $c->Q("
            SELECT id, edition, fascicle, origin, headline, seqnum, w, h
            FROM fascicles_pages
            WHERE fascicle = ? ",
        [ $source->{id} ])->Hashes;

    foreach my $page (@$source_pages) {

        my $page_id = $c->uuid();
        my $headline_id = $cache{ $page->{headline} };

        $cache{ $page->{id} } = $page_id;

        $c->Do("
            INSERT INTO fascicles_pages(id, edition, fascicle, origin, headline, seqnum, w, h, created, updated)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, now(), now());
        ", [ $page_id, $source->{edition}, $attachment_new, $page->{origin}, $headline_id, $page->{seqnum}, $page->{w}, $page->{h} ]);
    }

    # Import documents
    my $source_documents = $c->Q("
            SELECT *
            FROM documents
            WHERE fascicle = ? ",
        [ $source->{id} ])->Hashes;

    foreach my $document (@$source_documents) {

        my $document_edition = $source->{edition};
        my $document_fascicle = $attachment_new;

        my $document_headline = $c->get_record("indx_headlines", $document->{headline});
        my $document_rubric = $c->get_record("indx_headlines", $document->{rubric});

        my $new_id = Inprint::Models::Documents::copy(
            $c, $document,
            $document_edition, $document_fascicle,
            $document_headline, $document_rubric);

        # Remap document
        my $document_pages = $c->Q("
            SELECT *
            FROM fascicles_map_documents
            WHERE fascicle=? AND entity=? ",
        [ $source->{id}, $document->{id} ])->Hashes;

        foreach my $map (@$document_pages) {
            $c->Do("
                INSERT INTO
                    fascicles_map_documents
                        (edition, fascicle, page, entity, created, updated)
                VALUES
                        (?, ?, ?, ?, now(), now()); ",
                [ $source->{edition}, $attachment_new, $cache{ $map->{page} }, $new_id ]);
        }

    }

    # Import modules
    my $source_modules = $c->Q("
            SELECT *
            FROM fascicles_modules
            WHERE fascicle = ? ",
        [ $source->{id} ])->Hashes;

    foreach my $module (@$source_modules) {

        my $new_id = $c->uuid();

        $cache{ $module->{id} } = $new_id;

        $c->Do("
            INSERT INTO
                fascicles_modules (
                    id,
                    edition,fascicle,
                    place,
                    origin,
                    title,description,
                    amount,w,h,area,
                    width,height,fwidth,fheight,
                    created,updated
                )
            VALUES (
                ?,?,?,?,?,?,?,?,?,?,?,?,?,?,?, now(), now()
            ); ",
            [
                $new_id,
                $module->{edition}, $attachment_new,
                $cache{ $module->{place} },
                $cache{ $module->{origin} },
                $module->{title}, $module->{description},
                $module->{amount}, $module->{w}, $module->{h}, $module->{area},
                $module->{width}, $module->{height}, $module->{fwidth}, $module->{fheight}
            ]
        );

        # Remap module
        my $document_pages = $c->Q("
            SELECT *
            FROM fascicles_map_modules
            WHERE fascicle=? AND module=? ",
        [ $source->{id}, $module->{id} ])->Hashes;

        foreach my $map (@$document_pages) {
            $c->Do("
                INSERT INTO
                    fascicles_map_modules (
                        edition, fascicle, module,
                        page, placed, x, y,
                        created, updated)
                VALUES (
                    ?,?,?,?,?,?,?, now(), now()
                ); ",
                [
                    $source->{edition}, $attachment_new, $new_id,
                    $cache{ $map->{page} }, $map->{placed}, $map->{x}, $map->{y}
                ]
            );
        }

    }

    # Import requests
    my $source_requests = $c->Q("
            SELECT *
            FROM fascicles_requests
            WHERE fascicle = ? ",
        [ $source->{id} ])->Hashes;

    foreach my $request (@$source_requests) {

        my $new_id = $c->uuid();

        $c->Do("
            INSERT INTO
                fascicles_requests (
                    id,
                    edition, fascicle,
                    advertiser, advertiser_shortcut,
                    place, place_shortcut,
                    manager, manager_shortcut,
                    group_id, fs_folder,
                    amount,
                    origin, origin_shortcut, origin_area, origin_x, origin_y, origin_w, origin_h,
                    module,
                    pages, firstpage,
                    shortcut, description,
                    status, payment,
                    readiness, squib, check_status, anothers_layout, imposed,
                    created, updated
                )
                VALUES (
                    ?,
                    ?,?,
                    ?,?,
                    ?,?,
                    ?,?,
                    ?,?,
                    ?,
                    ?,?,?,?,?,?,?,
                    ?,
                    ?,?,
                    ?,?,
                    ?,?,
                    ?,?,?,?,?,
                    now(), now()
                );
            ",
            [
                $new_id,
                $request->{edition}, $attachment_new,
                $request->{advertiser}, $request->{advertiser_shortcut},
                $cache{ $request->{place} }, $request->{place_shortcut},
                $request->{manager}, $request->{manager_shortcut},
                $request->{group_id}, $request->{fs_folder},
                $request->{amount},
                $request->{origin}, $request->{origin_shortcut}, $request->{origin_area}, $request->{origin_x}, $request->{origin_y}, $request->{origin_w}, $request->{origin_h},
                $cache{ $request->{module} },
                $request->{pages}, $request->{firstpage},
                $request->{shortcut}, $request->{description},
                $request->{status}, $request->{payment},
                $request->{readiness}, $request->{squib}, $request->{check_status}, $request->{anothers_layout}, $request->{imposed}
            ]
        );

        # Remap request
        my $document_pages = $c->Q("
            SELECT *
            FROM fascicles_map_requests
            WHERE fascicle=? AND entity=? ",
        [ $source->{id}, $request->{id} ])->Hashes;

        foreach my $map (@$document_pages) {
            $c->Do("
                INSERT INTO
                    fascicles_map_requests (
                        edition, fascicle, entity,
                        page,
                        created, updated)
                VALUES (
                    ?,?,?,?, now(), now()
                ); ",
                [
                    $source->{edition}, $attachment_new, $new_id,
                    $cache{ $map->{page} }
                ]
            );
        }

    }

    $c->txCommit;

    return 1;
}


1;
