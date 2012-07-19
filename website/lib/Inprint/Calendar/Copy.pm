package Inprint::Calendar::Copy;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

sub copyFromDefaults {

    my $c    = shift;
    my $id   = shift;

    my %cache;

    my $fascicle = $c->Q("
        SELECT * FROM fascicles WHERE id=?;
        ", [ $id ])->Hash;

    my $edition = $c->Q("
        SELECT * FROM editions WHERE id=?; ",
        [ $fascicle->{edition} ])->Hash;

    my $editions = $c->Q("
        SELECT id FROM editions WHERE path @> ? order by path asc; ",
        [ $edition->{path} ])->Values;

    # Import Headlines && Rubrics

    my $headlines = $c->Q("
        SELECT id, tag, bydefault, title, description
        FROM indx_headlines
        WHERE edition = ANY(?) ",
        [ $editions ])->Hashes;

    foreach my $headline (@$headlines) {

        my $headline_id = $c->uuid();
        $cache{ $headline->{id} } = $headline_id;

        $c->Do("
            INSERT INTO fascicles_indx_headlines(id, edition, fascicle, tag, bydefault, title, description, created, updated)
            VALUES (?, ?, ?, ?, ?, ?, ?, now(), now()); ",
            [ $headline_id, $edition->{id}, $fascicle->{id}, $headline->{tag}, $headline->{bydefault}, $headline->{title}, $headline->{description} || "" ]);

        my $rubrics = $c->Q("
            SELECT id, tag, title, description
            FROM indx_rubrics WHERE headline=? ",
            [ $headline->{id} ])->Hashes;

        foreach my $rubric (@$rubrics) {
            my $rubric_id = $c->uuid();
            $c->Do("
                INSERT INTO fascicles_indx_rubrics(id, edition, fascicle, tag, headline, title, description, created, updated)
                VALUES (?, ?, ?, ?, ?, ?, ?, now(), now()); ",
                [ $rubric_id, $edition->{id}, $fascicle->{id}, $rubric->{tag}, $headline_id, $rubric->{title}, $rubric->{description} ]);
        }

    }

    # Import AD Pages && Modules

    my $tmpl_pages   = $c->Q("
            SELECT id, edition, title, description, bydefault, w, h, created, updated
            FROM ad_pages
            WHERE edition = ANY(?) ",
        [ $editions ])->Hashes;

    foreach my $page (@$tmpl_pages) {

        my $page_id = $c->uuid;

        $c->Do("
            INSERT INTO fascicles_tmpl_pages(id, origin, fascicle, title, description, bydefault, w, h, created, updated)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, now(), now());
        ", [ $page_id, $page->{id}, $id, $page->{title}, $page->{description}, $page->{bydefault}, $page->{w}, $page->{h} ]);

        my $tmpl_modules = $c->Q("
            SELECT
                id, edition, page,
                title, description,
                amount, area,
                x, y, w, h,
                width, height, fwidth, fheight,
                created, updated
            FROM ad_modules WHERE page=? ", [ $page->{id} ])->Hashes;

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
                    $module_id, $tmpl_module->{id}, $id, $page_id,
                    $tmpl_module->{title}, $tmpl_module->{description},
                    $tmpl_module->{amount}, $tmpl_module->{area},
                    $tmpl_module->{x}, $tmpl_module->{y}, $tmpl_module->{w}, $tmpl_module->{h},
                    $tmpl_module->{width}, $tmpl_module->{height}, $tmpl_module->{fwidth}, $tmpl_module->{fheight} ]);

        }

    }

    # Import Places

    my $tmpl_places  = $c->Q("
            SELECT id, edition, title, description, created, updated
            FROM ad_places
            WHERE edition = ANY(?) ",
        [ $editions ])->Hashes;

    foreach my $place (@$tmpl_places) {

        my $place_id = $c->uuid();
        $cache{ $place->{id} } = $place_id;

        $c->Do("
            INSERT INTO fascicles_tmpl_places(id, origin, fascicle, title, description, created, updated)
                VALUES (?, ?, ?, ?, ?, now(), now());
        ", [ $place_id, $place->{id}, $id, $place->{title}, $place->{description} ]);

    }

    # Import AD Index

    my $tmpl_places_index = $c->Q("
            SELECT id, edition, place, nature, entity, created, updated
            FROM ad_index WHERE edition = ?
        ", [ $edition->{id} ])->Hashes;

    foreach my $indx (@$tmpl_places_index) {

        my $indx_id = $c->uuid();

        my $place_id = $cache{ $indx->{place} };
        my $entity_id = $cache{ $indx->{entity} };

        next unless $place_id;
        next unless $entity_id;

        $c->Do("
            INSERT INTO fascicles_tmpl_index(id, edition, fascicle, place, nature, entity, created, updated)
                VALUES (?, ?, ?, ?, ?, ?, now(), now());
        ", [ $indx_id, $edition->{id}, $id, $place_id, $indx->{nature}, $entity_id ]);

    }

    return \%cache;
}

sub copyFromIssue {

    my $c    = shift;
    my $to   = shift;
    my $from = shift;

    my %cache;

    my $fascicle = $c->Q("
        SELECT * FROM fascicles WHERE id=?;
        ", [ $to ])->Hash;

    my $edition = $c->Q("
        SELECT * FROM editions WHERE id=?; ",
        [ $fascicle->{edition} ])->Hash;

    my $source = $c->Q("
        SELECT * FROM fascicles WHERE id=?;
        ", [ $from ])->Hash;

    return unless ($edition->{id});
    return unless ($fascicle->{id});
    return unless ($source->{id});    
    
    if ($source->{adv_modules}) {
        unless($fascicle->{adv_modules}) {
            $c->Do("UPDATE fascicles SET adv_modules=? WHERE id=?", [ $source->{adv_modules}, $fascicle->{id} ]);
        }
    }
    
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
            INSERT INTO fascicles_indx_headlines(id, edition, fascicle, tag, bydefault, title, description, created, updated)
            VALUES (?, ?, ?, ?, ?, ?, ?, now(), now()); ",
            [ $headline_id, $edition->{id}, $fascicle->{id}, $headline->{tag}, $headline->{bydefault}, $headline->{title}, $headline->{description} || "" ]);

        my $rubrics = $c->Q("
            SELECT id, tag, title, description
            FROM fascicles_indx_rubrics WHERE headline=? ",
            [ $headline->{id} ])->Hashes;

        foreach my $rubric (@$rubrics) {
            my $rubric_id = $c->uuid();
            $c->Do("
                INSERT INTO fascicles_indx_rubrics(id, edition, fascicle, tag, headline, title, description, created, updated)
                VALUES (?, ?, ?, ?, ?, ?, ?, now(), now()); ",
                [ $rubric_id, $edition->{id}, $fascicle->{id}, $rubric->{tag}, $headline_id, $rubric->{title}, $rubric->{description} ]);
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
            INSERT INTO fascicles_tmpl_pages(id, origin, fascicle, title, description, bydefault, w, h, created, updated)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, now(), now());
        ", [ $page_id, $page->{origin}, $fascicle->{id}, $page->{title}, $page->{description}, $page->{bydefault}, $page->{w}, $page->{h} ]);

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
                    $module_id, $tmpl_module->{origin}, $fascicle->{id}, $page_id,
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
        ", [ $place_id, $place->{origin}, $fascicle->{id}, $place->{title}, $place->{description} ]);

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
        ", [ $indx_id, $edition->{id}, $fascicle->{id}, $place_id, $indx->{nature}, $entity_id ]);

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

        $c->Do("
            INSERT INTO fascicles_pages(id, edition, fascicle, origin, headline, seqnum, w, h, created, updated)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, now(), now());
        ", [ $page_id, $edition->{id}, $fascicle->{id}, $page->{origin}, $headline_id, $page->{seqnum}, $page->{w}, $page->{h} ]);

    }
}

sub clearFascicle {
    my $c    = shift;
    my $to   = shift;

    $c->sql->Do("DELETE FROM fascicles_indx_rubrics WHERE fascicle=?", $to);
    $c->sql->Do("DELETE FROM fascicles_indx_headlines WHERE fascicle=?", $to);

    $c->sql->Do("DELETE FROM fascicles_map_documents WHERE fascicle=?", $to);
    $c->sql->Do("DELETE FROM fascicles_map_modules WHERE fascicle=?", $to);
    $c->sql->Do("DELETE FROM fascicles_map_requests WHERE fascicle=?", $to);

    $c->sql->Do("DELETE FROM fascicles_modules WHERE fascicle=?", $to);
    $c->sql->Do("DELETE FROM fascicles_pages WHERE fascicle=?", $to);

    $c->sql->Do("DELETE FROM fascicles_tmpl_index WHERE fascicle=?", $to);
    $c->sql->Do("DELETE FROM fascicles_tmpl_modules WHERE fascicle=?", $to);
    $c->sql->Do("DELETE FROM fascicles_tmpl_pages WHERE fascicle=?", $to);
    $c->sql->Do("DELETE FROM fascicles_tmpl_places WHERE fascicle=?", $to);

}

sub copyFromTemplate {

    my $c    = shift;
    my $to   = shift;
    my $tmpl = shift;

    my %cache;

    my $fascicle = $c->Q("
        SELECT * FROM fascicles WHERE id=?;
        ", [ $to ])->Hash;

    my $edition = $c->Q("
        SELECT * FROM editions WHERE id=?; ",
        [ $fascicle->{edition} ])->Hash;

    my $template = $c->Q("
        SELECT * FROM template WHERE id=?;
        ", [ $tmpl ])->Hash;

    return unless ($fascicle->{id});
    return unless ($template->{id});

    clearFascicle($c, $to);
    my $cache = copyFromDefaults($c, $to);

    # Import templates

    $c->Do("
        UPDATE fascicles
            SET
                tmpl=?,
                tmpl_shortcut=?,
                adv_modules=?
        WHERE id=? ",
        [ $template->{id}, $template->{shortcut}, $template->{adv_modules}, $fascicle->{id} ]);

    my $pages = $c->Q("
        SELECT
            id, edition, template, origin, headline, seqnum, width, height,
            created, updated
        FROM template_page
        WHERE template = ? ",
        [ $tmpl ])->Hashes;

    foreach my $page (@$pages) {

        my $page_id = $c->uuid();

        $cache{ $page->{id} } = $page_id;

        my $headline = $cache->{$page->{headline}};

        my $tmplpage = $c->Q("
            SELECT * FROM fascicles_tmpl_pages
            WHERE origin=? AND fascicle = ?
        ", [ $page->{origin}, $fascicle->{id} ])->Hash;

        $c->Do("
            INSERT INTO fascicles_pages
                ( id, edition, fascicle, origin, headline, seqnum, w, h, created, updated)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, now(), now()); ",
            [
                $page_id,
                $fascicle->{edition},
                $fascicle->{id},
                $tmplpage->{id},
                $headline,
                $page->{seqnum},
                $page->{width},
                $page->{height}
            ]
        );
    }

    # Import modules

    my $modules = $c->Q("
        SELECT
            id, edition, template, place, origin, title, description, amount,
            w, h, area, created, updated, width, height, fwidth, fheight
        FROM template_module
        WHERE template = ? ",
        [ $tmpl ])->Hashes;

    foreach my $module (@$modules) {

        my $module_id = $c->uuid();

        my $place_id  = $cache->{$module->{place}};
        my $origin_id = $cache->{$module->{origin}};

        $c->Do("
            INSERT INTO fascicles_modules
                ( id, edition, fascicle, place, origin, title, description, amount,
                    w, h, area, width, height, fwidth, fheight, created, updated )
                VALUES (
                    ?,
                    ?, ?, ?, ?,
                    ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,
                    now(), now()); ",
            [

                $module_id,

                $fascicle->{edition},
                $fascicle->{id},
                $place_id,
                $origin_id,

                $module->{title},
                $module->{description},
                $module->{amount},
                $module->{w},
                $module->{h},
                $module->{area},
                $module->{width},
                $module->{height},
                $module->{fwidth},
                $module->{fheight}
            ]
        );

        my $maps = $c->Q("
            SELECT
                id, edition, template, module, page, placed, x, y, created, updated
            FROM template_map_module
            WHERE template = ? AND module=?",
            [ $tmpl, $module->{id} ])->Hashes;

        foreach my $map (@$maps) {

            my $page_id = $cache{ $map->{page} };

            $c->Do("
                INSERT INTO fascicles_map_modules
                    ( edition, fascicle, module, page, placed, x, y, created, updated )
                    VALUES (
                        ?, ?, ?, ?,
                        ?, ?, ?,
                        now(), now()); ",
                [

                    $fascicle->{edition},
                    $fascicle->{id},

                    $module_id,
                    $page_id,

                    $map->{placed},
                    $map->{x},
                    $map->{y}
                ]
            );

        }

    }

}

1;
