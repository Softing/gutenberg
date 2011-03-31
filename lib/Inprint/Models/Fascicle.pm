package Inprint::Models::Fascicle;

use strict;
use warnings;

sub create {
    my $c = shift;

    my ($id, $edition, $parent, $fastype, $variation,
        $shortcut, $description,
        $circulation, $pnum, $anum, $manager, $enabled, $archived, $flagdoc,
        $flagadv, $datedoc, $dateadv, $dateprint, $dateout) = @_;

    $c->Do("
        INSERT INTO fascicles(
            id, edition, parent, fastype, variation, shortcut, description,
            circulation, pnum, anum, manager, enabled, archived, flagdoc,
            flagadv, datedoc, dateadv, dateprint, dateout, created, updated)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, now(), now());

    ", [ $id, $edition, $parent, $fastype, $variation, $shortcut, $description,
        $circulation, $pnum, $anum, $manager, $enabled, $archived, $flagdoc,
        $flagadv, $datedoc, $dateadv, $dateprint, $dateout ]);

    return $c;
}

sub read {
    my $c = shift;
    my $id = shift;

    my $result = $c->Q("
        SELECT
            id, edition, parent, fastype, variation,
            shortcut, description,
            circulation, pnum, anum,
            manager,
            enabled, archived,
            flagdoc, flagadv,

            to_char(datedoc, 'YYYY-MM-DD HH24:MI:SS')   as datedoc,
            to_char(dateadv, 'YYYY-MM-DD HH24:MI:SS')   as dateadv,
            to_char(dateprint, 'YYYY-MM-DD HH24:MI:SS')   as dateprint,
            to_char(dateout, 'YYYY-MM-DD HH24:MI:SS')   as dateout,

            to_char(created, 'YYYY-MM-DD HH24:MI:SS') as created,
            to_char(updated, 'YYYY-MM-DD HH24:MI:SS') as updated
        FROM fascicles
        WHERE id=?
    ", [ $id ])->Hash;

    return $result;
}

sub update {
    my $c = shift;

    my ($id, $enabled, $title, $shortcut,
        $description, $deadline, $advertisement ) = @_;

    $c->Do("
        UPDATE fascicles
            SET enabled=?, title=?, shortcut=?, description=?, deadline=?, advert_deadline=?
        WHERE id =?;
    ", [ $enabled, $title, $shortcut, $deadline, $deadline, $advertisement, $id ]);

    return $c;
}

sub delete {
    my $c  = shift;
    my $id = shift;

    $c->Do(" DELETE FROM fascicles_requests WHERE fascicle=? ", [ $id ]);

    $c->Do(" DELETE FROM fascicles_modules WHERE fascicle=? ", [ $id ]);
    $c->Do(" DELETE FROM fascicles_options WHERE fascicle=? ", [ $id ]);
    $c->Do(" DELETE FROM fascicles_pages WHERE fascicle=? ", [ $id ]);

    $c->Do(" DELETE FROM fascicles_indx_rubrics WHERE fascicle=? ", [ $id ]);
    $c->Do(" DELETE FROM fascicles_indx_headlines WHERE fascicle=? ", [ $id ]);

    $c->Do(" DELETE FROM fascicles_tmpl_index WHERE fascicle=? ", [ $id ]);
    $c->Do(" DELETE FROM fascicles_tmpl_modules WHERE fascicle=? ", [ $id ]);
    $c->Do(" DELETE FROM fascicles_tmpl_pages WHERE fascicle=? ", [ $id ]);
    $c->Do(" DELETE FROM fascicles_tmpl_places WHERE fascicle=? ", [ $id ]);

    $c->Do(" DELETE FROM fascicles WHERE id=? ", [ $id ]);

    return $c;
}

sub importFromDefaults {

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

    my $tmpl_pages   = $c->Q(
        " SELECT id, edition, title, description, bydefault, w, h, created, updated FROM ad_pages WHERE edition = ANY(?) ",
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

    my $tmpl_places  = $c->Q(" SELECT id, edition, title, description, created, updated FROM ad_places WHERE edition = ANY(?) ", [ $editions ])->Hashes;

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

sub importFromFascicle {
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
            [ $headline_id, $fascicle->{edition}, $fascicle->{id}, $headline->{tag}, $headline->{bydefault}, $headline->{title}, $headline->{description} || "" ]);

        my $rubrics = $c->Q("
            SELECT id, tag, title, description
            FROM fascicles_indx_rubrics WHERE headline=? ",
            [ $headline->{id} ])->Hashes;

        foreach my $rubric (@$rubrics) {
            my $rubric_id = $c->uuid();
            $c->Do("
                INSERT INTO fascicles_indx_rubrics(id, edition, fascicle, tag, headline, title, description, created, updated)
                VALUES (?, ?, ?, ?, ?, ?, ?, now(), now()); ",
                [ $rubric_id, $fascicle->{edition}, $fascicle->{id}, $rubric->{tag}, $headline_id, $rubric->{title}, $rubric->{description} ]);
        }

    }

    # Import AD Pages && Modules

    my $tmpl_pages   = $c->Q(
        " SELECT id, title, description, bydefault, w, h FROM fascicles_tmpl_pages WHERE fascicle = ? ",
        [ $source->{id} ])->Hashes;

    foreach my $page (@$tmpl_pages) {

        my $page_id = $c->uuid;

        $c->Do("
            INSERT INTO fascicles_tmpl_pages(id, origin, fascicle, title, description, bydefault, w, h, created, updated)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, now(), now());
        ", [ $page_id, $page->{id}, $id, $page->{title}, $page->{description}, $page->{bydefault}, $page->{w}, $page->{h} ]);

        my $tmpl_modules = $c->Q("
            SELECT id, page, title, description, amount, area, x, y, w, h, created, updated
            FROM fascicles_tmpl_modules WHERE page=? ", [ $page->{id} ])->Hashes;

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
        SELECT id, title, description, created, updated
        FROM fascicles_tmpl_places WHERE fascicle=? ",
        [ $source->{id} ])->Hashes;

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
            SELECT id, place, nature, entity, created, updated
            FROM fascicles_tmpl_index WHERE fascicle = ?
        ", [ $source->{id} ])->Hashes;

    foreach my $indx (@$tmpl_places_index) {

        my $indx_id = $c->uuid();

        my $place_id = $cache{ $indx->{place} };
        my $entity_id = $cache{ $indx->{entity} };

        next unless $place_id;
        next unless $entity_id;

        $c->Do("
            INSERT INTO fascicles_tmpl_index(id, edition, fascicle, place, nature, entity, created, updated)
                VALUES (?, ?, ?, ?, ?, ?, now(), now());
        ", [ $indx_id, $fascicle->{edition}, $id, $place_id, $indx->{nature}, $entity_id ]);

    }

}

1;
