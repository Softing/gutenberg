package Inprint::Fascicle::Modules;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use utf8;
use strict;
use warnings;

use Inprint::Fascicle::Events;

use base 'Mojolicious::Controller';

sub read {
    my $c = shift;

    my $i_id    = $c->param("id");
    my @i_pages = $c->param("page");

    my @errors;
    my $success = $c->json->false;

    push @errors, { id => "id", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_id));

    my @pages;
    my $result = [];

    foreach (@i_pages) {
        my ($page, $seqnum) = split '::', $_;
        push @pages, $page;
    }

    unless (@errors) {

        $result = $c->Q("
            SELECT id, edition, fascicle, origin, title, description, amount, area, w, h, created, updated
            FROM fascicles_modules
            WHERE id=?;
        ", [ $i_id ])->Hash;

        #$result->{pages} = $c->Q("
        #    SELECT page, module
        #    FROM fascicles_map_modules WHERE module=?
        #", [ $result->{id} ])->Hashes;
        #
        #my $pages = $c->Q("
        #    SELECT DISTINCT page FROM fascicles_map_modules WHERE module=?
        #", [ $result->{id} ])->Values;

        $result->{composition} = $c->Q("
            SELECT t2.page, t1.id, t1.title, t1.w, t1.h, t2.x, t2.y
            FROM fascicles_modules t1, fascicles_map_modules t2
            WHERE page=ANY(?) AND t2.module=t1.id
        ", [ \@pages ])->Hashes;

    }

    $success = $c->json->true unless (@errors);
    $c->render_json( { success => $success, errors => \@errors, data => $result } );
}

sub list {
    my $c = shift;

    my @i_pages    = $c->param("page");

    my $result = [];

    my @errors;
    my $success = $c->json->false;

    my $sql;
    my @params;

    my @pages;

    unless (@errors) {

        foreach my $code (@i_pages) {
            my ($page_id, $seqnum) = split '::', $code;

            my $page = $c->Q("
                SELECT id, edition, fascicle, origin, headline, seqnum, w, h, created, updated
                FROM fascicles_pages WHERE id=? AND seqnum=?
            ", [ $page_id, $seqnum ])->Hash;

            next unless $page->{id};

            push @pages, $page->{id};
        }

        $sql = "
            SELECT DISTINCT
                t1.id, t1.edition, t1.fascicle,t1.origin, t1.title,
                t1.description, t1.amount, t1.area, t1.created, t1.updated,
                t3.id as place, t3.title as place_title,
                ( SELECT count(*) FROM fascicles_map_modules WHERE module=t1.id ) as count
            FROM
                fascicles_modules t1
                    LEFT JOIN fascicles_tmpl_places t3 ON ( t1.place = t3.id ),
                fascicles_map_modules t2
            WHERE t2.module=t1.id AND t2.page = ANY(?)
        ";

        push @params, \@pages;

    }

    unless (@errors) {
        $result = $c->Q(" $sql ", \@params)->Hashes;
        $c->render_json( { data => $result } );
    }

    $success = $c->json->true unless (@errors);
    $c->render_json( { success => $success, errors => \@errors, data => $result } );
}

sub create {

    my $c = shift;

    my $id = $c->uuid();

    my $i_fascicle    = $c->param("fascicle");
    my $i_template    = $c->param("template");
    my @i_pages       = $c->param("pages");

    my @errors;
    my $success = $c->json->false;

    #push @errors, { id => "access", msg => "Not enough permissions"}
    #    unless ($c->objectAccess("domain.roles.manage"));

    my $fascicle = $c->check_record(\@errors, "fascicles", "fascicle", $i_fascicle);

    $c->fail_render(\@errors);

    # Find module
    my $module = $c->Q("
        SELECT
            t1.id,
            t2.place as place,
            t1.origin, t1.fascicle, t1.page,
            t1.title, t1.description,
            t1.amount, t1.area,
            t1.x, t1.y, t1.w, t1.h,
            t1.width, t1.height, t1.fwidth, t1.fheight,
            t1.created, t1.updated
        FROM fascicles_tmpl_modules t1, fascicles_tmpl_index t2
        WHERE t1.id=t2.entity AND t2.id=?
    ", [ $i_template ])->Hash;

    push @errors, { id => "module", msg => "Object not found"} unless $module->{id};

    $c->fail_render(\@errors);

    # Find pages
    my @pages;
    foreach my $code (@i_pages) {

        my ($page_id, $seqnum) = split '::', $code;

        my $page = $c->Q("
            SELECT id, edition, fascicle, origin, headline, seqnum, w, h, created, updated
            FROM fascicles_pages WHERE id=? AND seqnum=?
        ", [ $page_id, $seqnum ])->Hash;

        next unless $page->{id};
        push @pages, $page;
    }

    push @errors, { id => "page", msg => "Pages not equal $#i_pages"}
        unless ($#pages == $#i_pages);

    $c->fail_render(\@errors);

    my $module_id = $c->uuid;

    $c->Do("
        INSERT INTO fascicles_modules
            (
                id, edition, fascicle, place, origin,
                title, description,
                amount, area,
                w, h,
                width, height, fwidth, fheight,
                created, updated)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, now(), now());
    ", [
        $module_id, $fascicle->{edition}, $fascicle->{id},
        $module->{place},
        $module->{id}, $module->{title}, $module->{description},
        $module->{amount}, $module->{area},
        $module->{w}, $module->{h},
        $module->{width}, $module->{height}, $module->{fwidth}, $module->{fheight}
    ]);

    foreach my $page (@pages) {
        $c->Do("
            INSERT INTO fascicles_map_modules
            (edition, fascicle, module, page, placed, x, y, created, updated)
            VALUES
            (?, ?, ?, ?, ?, ?, ?, now(), now());
        ", [ $fascicle->{edition}, $fascicle->{id}, $module_id, $page->{id}, 0, "1/1", "1/1" ]);
    }

    # Create event
    Inprint::Fascicle::Events::onCompositionChanged($c, $fascicle);

    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors });
}

sub update {
    my $c = shift;

    my $i_id          = $c->param("id");
    my $i_title       = $c->param("title");
    my $i_description = $c->param("description");

    my $i_amount      = $c->param("amount") // 1;
    my $i_amount0     = $c->param("amount0") // 0;

    my $i_x           = $c->param("x") // "1/1";
    my $i_y           = $c->param("y") // "1/1";

    my $i_w           = $c->param("w") // "1/1";
    my $i_h           = $c->param("h") // "1/1";

    my @errors;
    my $success = $c->json->false;

    push @errors, { id => "id", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_id));

    push @errors, { id => "title", msg => "Incorrectly filled field"}
        unless ($c->is_text($i_title));

    push @errors, { id => "description", msg => "Incorrectly filled field"}
        unless ($c->is_text($i_description));

    #push @errors, { id => "access", msg => "Not enough permissions"}
    #    unless ($c->objectAccess("domain.roles.manage"));

    push @errors, { id => "amount", msg => "Incorrectly filled field"}
        unless ($c->is_int($i_amount));

    if ($i_x) {
        push @errors, { id => "x", msg => "Incorrectly filled field"}
            unless ($c->is_text($i_x));
    }

    if ($i_y) {
        push @errors, { id => "y", msg => "Incorrectly filled field"}
            unless ($c->is_text($i_y));
    }

    if ($i_w) {
        push @errors, { id => "w", msg => "Incorrectly filled field"}
            unless ($c->is_text($i_w));
    }

    if ($i_h) {
        push @errors, { id => "h", msg => "Incorrectly filled field"}
            unless ($c->is_text($i_h));
    }

    my $area = 0;
    my $size_w = 0;
    my $size_h = 0;

    my ($w1, $w2) = split '/', $i_w;
    my ($h1, $h2) = split '/', $i_h;

    $size_w = $w1/$w2;
    $size_h = $h1/$h2;

    unless ($i_amount0) {
        $area = $size_w * $size_h * $i_amount;
    }

    unless (@errors) {
        $c->Do("
            UPDATE fascicles_tmpl_modules
                SET title=?, description=?, amount=?, area=?, x=?, y=?, w=?, h=?, updated=now()
            WHERE id =?;
        ", [ $i_title, $i_description, $i_amount, $area, $i_x, $i_y, $i_w, $i_h, $i_id ]);
    }

    # Create event
    #Inprint::Fascicle::Events::onCompositionChanged($c, $fascicle);

    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors });
}

sub delete {
    my $c = shift;

    my @errors;

    my @ids        = $c->param("id");
    my $i_fascicle = $c->param("fascicle");

    my $fascicle = $c->check_record(\@errors, "fascicles", "fascicle", $i_fascicle);

    #push @errors, { id => "access", msg => "Not enough permissions"}
    #    unless ($c->objectAccess("domain.roles.manage"));

    unless (@errors) {
        foreach my $id (@ids) {

            my $module;

            if ($c->is_uuid($id)) {
                $module = $c->Q(" SELECT * FROM fascicles_modules WHERE id=? ", [ $id ])->Hash;
            }

            if ($module->{id}) {
                $c->Do(" DELETE FROM fascicles_modules WHERE id=? ", [ $module->{id} ]);
                $c->Do(" DELETE FROM fascicles_map_modules WHERE module=? ", [ $module->{id} ]);
            }

        }
    }

    # Create event
    Inprint::Fascicle::Events::onCompositionChanged($c, $fascicle);

    $c->smart_render(\@errors);
}

1;
