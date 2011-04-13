package Inprint::Calendar::Copy;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

sub copy {

    my ($c, $from, $to)  = @_;

    if ($to eq "00000000-0000-0000-0000-000000000000") {
        copyFromDefaults($c, $from);
    }

    return $c;
}

sub copyFromDefaults {

    my $c  = shift;
    my $id = shift;

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
            SELECT id, edition, page, title, description, amount, area, x, y, w, h, created, updated
            FROM ad_modules WHERE page=? ", [ $page->{id} ])->Hashes;

        foreach my $module (@$tmpl_modules) {

            my $module_id = $c->uuid();
            $cache{ $module->{id} } = $module_id;

            $c->Do("
                INSERT INTO fascicles_tmpl_modules(id, origin, fascicle, page, title, description, amount, area, x, y, w, h, created, updated)
                    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, now(), now());
            ", [ $module_id, $module->{id},  $id, $page_id, $module->{title}, $module->{description}, $module->{amount}, $module->{area}, $module->{x}, $module->{y}, $module->{w}, $module->{h} ]);

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

}

sub copyFromFascicle {
    my $c   = shift;
    my $id  = shift;
    my $sid = shift;

    my %cache;

    my $fascicle = $c->Q("
        SELECT * FROM fascicles WHERE id=?;
        ", [ $id ])->Hash;

    my $source = $c->Q("
        SELECT * FROM fascicles WHERE id=?;
        ", [ $sid ])->Hash;

}

sub copyFascicle {

    my ($c, $id_from, $id_to, $settings) = @_;

    my $source = $c->Q("
        SELECT * FROM fascicles WHERE id=?;
        ", [ $id_from ])->Hash;

    return 0 unless $source->{id};

    $source->{parent}  = $settings->{parent}  if ($settings->{parent});
    $source->{fastype} = $settings->{fastype} if ($settings->{fastype});

    $c->Do("
            INSERT INTO fascicles(
                    id,
                    edition, parent, fastype, variation,
                    shortcut, description,
                    circulation, manager, enabled, archived, doc_date, adv_date,
                    print_date, release_date, num, anum, deleted,
                    adv_enabled, doc_enabled, tmpl, tmpl_shortcut, created, updated)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, now(), now()); ",
        [
            $id_to,
            $source->{edition}, $source->{parent}, $source->{fastype},
            $source->{variation}, $source->{shortcut}, $source->{description},
            $source->{circulation}, $source->{manager}, $source->{enabled},
            $source->{archived},$source->{doc_date}, $source->{adv_date},
            $source->{print_date}, $source->{release_date}, $source->{created},
            $source->{updated}, $source->{num}, $source->{anum}, $source->{deleted},
            $source->{adv_enabled}, $source->{doc_enabled}, $source->{tmpl},
            $source->{tmpl_shortcut}
        ]);

    return $id_to;
}

sub copyFascicleIndex {

    my ($c, $id_from, $id_to) = @_;

    my $source = $c->Q("
        SELECT * FROM fascicles WHERE id=?;
        ", [ $id_from ])->Hash;

    my $destination = $c->Q("
        SELECT * FROM fascicles WHERE id=?;
        ", [ $id_to ])->Hash;

    return 0 unless $source->{id};
    return 0 unless $destination->{id};

    my $headlines = $c->Q("
        SELECT id, tag, bydefault, title, description
        FROM fascicles_indx_headlines
        WHERE fascicle = ? ",
        [ $source->{id} ])->Hashes;

    foreach my $headline (@$headlines) {

        my $headline_id = $c->uuid();

        $c->Do("
            INSERT INTO fascicles_indx_headlines
                (id, edition, fascicle, tag, bydefault, title, description, created, updated)
                VALUES (?, ?, ?, ?, ?, ?, ?, now(), now()); ",
            [
                $headline_id,
                $destination->{edition}, $destination->{id},
                $headline->{tag}, $headline->{bydefault}, $headline->{title}, $headline->{description} ]);

        my $rubrics = $c->Q("
                SELECT id, tag, title, description
                FROM fascicles_indx_rubrics
                WHERE fascicle=? AND headline=? ",
            [ $source->{id}, $headline->{id} ])->Hashes;

        foreach my $rubric (@$rubrics) {

            my $rubric_id = $c->uuid();

            $c->Do("
                INSERT INTO fascicles_indx_rubrics
                    (id, edition, fascicle, tag, headline, title, description, created, updated)
                    VALUES (?, ?, ?, ?, ?, ?, ?, now(), now()); ",
                [
                    $rubric_id,
                    $destination->{edition}, $destination->{id},
                    $rubric->{tag}, $headline_id, $rubric->{title}, $rubric->{description} ]);
        }

    }

    return $id_to;
}

sub copyFasciclePages {

    my ($c, $id_from, $id_to) = @_;

    my $source = $c->Q("
        SELECT * FROM fascicles WHERE id=?;
        ", [ $id_from ])->Hash;

    my $destination = $c->Q("
        SELECT * FROM fascicles WHERE id=?;
        ", [ $id_to ])->Hash;

    return 0 unless $source->{id};
    return 0 unless $destination->{id};


}

sub copyFascicleTemplates {

    my ($c, $id_from, $id_to) = @_;

    my $source = $c->Q("
        SELECT * FROM fascicles WHERE id=?;
        ", [ $id_from ])->Hash;

    my $destination = $c->Q("
        SELECT * FROM fascicles WHERE id=?;
        ", [ $id_to ])->Hash;

    return 0 unless $source->{id};
    return 0 unless $destination->{id};

    my $cache_pages = {};
    my $cache_modules = {};

    # Get page templates

    my $src_pages   = $c->Q(
        " SELECT id, title, description, bydefault, w, h FROM fascicles_tmpl_pages WHERE fascicle = ? ",
        [ $source->{id} ])->Hashes;

    # Import pages
    foreach my $src_page (@$src_pages) {

        my $page_id = $c->uuid;

        $cache_pages->{ $src_pages->{id} } = $page_id;

        $c->Do("
            INSERT INTO fascicles_tmpl_pages
                (id, fascicle, origin, title, description, bydefault, w, h, created, updated)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, now(), now()); ",
            [
                $page_id, $destination->{id}, $src_pages->{id},
                $src_pages->{title}, $src_pages->{description}, $src_pages->{bydefault}, $src_pages->{w}, $src_pages->{h} ]);

        # Get module templates

        my $src_modules = $c->Q("
                SELECT id, page, title, description, amount, area, x, y, w, h, created, updated
                FROM fascicles_tmpl_modules
                WHERE fascicle=? AND page=? ",
            [ $source->{id}, $src_pages->{id} ])->Hashes;

        # Import modules
        foreach my $src_module (@$src_modules) {

            my $module_id = $c->uuid();

            $cache_modules->{ $src_module->{id} } = $module_id;

            $c->Do("
                INSERT INTO fascicles_tmpl_modules
                    (id, fascicle, origin, page, title, description, amount, area, x, y, w, h, created, updated)
                    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, now(), now()); ",
                [
                    $module_id, $destination->{id}, $src_module->{id}, $page_id,
                    $src_module->{title}, $src_module->{description}, $src_module->{amount}, $src_module->{area}, $src_module->{x}, $src_module->{y}, $src_module->{w}, $src_module->{h} ]);

        }

    }

    # Get places

    my $src_places  = $c->Q("
        SELECT id, title, description, created, updated
        FROM fascicles_tmpl_places WHERE fascicle=? ",
        [ $source->{id} ])->Hashes;

    # Import places
    foreach my $src_place (@$src_places) {

        my $place_id = $c->uuid();

        # Import places
        $c->Do("
            INSERT INTO fascicles_tmpl_places
                (id, fascicle, origin, title, description, created, updated)
                VALUES (?, ?, ?, ?, ?, now(), now());
        ", [
                $place_id,
                $destination->{id}, $src_place->{id},
                $src_place->{title}, $src_place->{description} ]);

        # Get AD Index
        my $src_ad_index = $c->Q("
                SELECT id, place, nature, entity, created, updated
                FROM fascicles_tmpl_index
                WHERE fascicle=? AND place=?
            ", [ $source->{id}, $src_place->{id} ])->Hashes;

        # Import AD index
        #foreach my $src_indx (@$src_ad_index) {
        #
        #    my $indx_id = $c->uuid();
        #
        #    my $nature;
        #    my $entity;
        #
        #    $c->Do("
        #        INSERT INTO fascicles_tmpl_index
        #            (id, edition, fascicle, place, nature, entity, created, updated)
        #            VALUES (?, ?, ?, ?, ?, ?, now(), now());
        #    ", [
        #        $indx_id,
        #        $destination->{edition}, $destination->{id},
        #        $place_id, $nature, $entity ]);
        #}

    }

    return $id_to;
}

1;
