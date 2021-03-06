package Inprint::Advertising::Modules;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use utf8;
use strict;
use warnings;

use base 'Mojolicious::Controller';

sub read {
    my $c = shift;
    my $i_id = $c->param("id");

    my @errors;
    my $success = $c->json->false;

    push @errors, { id => "id", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_id));

    my $result = [];

    unless (@errors) {
        $result = $c->Q("
            SELECT
                id, edition, page,
                title, description,
                amount, area,
                x, y, w, h,
                width, height, fwidth, fheight,
                created, updated
            FROM ad_modules
            WHERE id=?;
        ", [ $i_id ])->Hash;
    }

    $success = $c->json->true unless (@errors);
    $c->render_json( { success => $success, errors => \@errors, data => $result } );
}

sub list {
    my $c = shift;

    my $i_edition = $c->param("edition");
    my $i_page    = $c->param("page");

    my $result = [];

    my @errors;
    my $success = $c->json->false;

    push @errors, { id => "edition", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_edition));

    push @errors, { id => "page", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_page));

    my $edition; unless (@errors) {
        $edition  = $c->Q(" SELECT * FROM editions WHERE id=? ", [ $i_edition ])->Hash;
        push @errors, { id => "edition", msg => "Incorrectly filled field"}
            unless ($edition);
    }

    my $page; unless (@errors) {
        $page  = $c->Q(" SELECT * FROM ad_pages WHERE id=?", [ $i_page ])->Hash;
        push @errors, { id => "page", msg => "Incorrectly filled field"}
            unless ($page);
    }

    my $sql;
    my @params;

    unless (@errors) {
        $sql = "
            SELECT
                id, edition, page,
                title, description,
                amount, round(area::numeric, 2) as area,
                x, y, w, h,
                width, height, fwidth, fheight,
                created, updated
            FROM ad_modules
            WHERE page=?
            ORDER BY title
        ";
        push @params, $page->{id};
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

    my $i_edition     = $c->param("edition");
    my $i_page        = $c->param("page");

    my $i_title       = $c->param("title");
    my $i_description = $c->param("description");

    my $i_amount      = $c->param("amount")  // 1;

    my $i_x           = $c->param("x")       // "1/1";
    my $i_y           = $c->param("y")       // "1/1";
    my $i_w           = $c->param("w")       // "1/1";
    my $i_h           = $c->param("h")       // "1/1";

    my $i_width       = $c->param("width")   // 0;
    my $i_height      = $c->param("height")  // 0;
    my $i_fwidth      = $c->param("fwidth")  // 0;
    my $i_fheight     = $c->param("fheight") // 0;

    my @errors;
    my $success = $c->json->false;

    push @errors, { id => "title", msg => "Incorrectly filled field"}
        unless ($c->is_text($i_title));

    push @errors, { id => "description", msg => "Incorrectly filled field"}
        unless ($c->is_text($i_description));

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

    #push @errors, { id => "access", msg => "Not enough permissions"}
    #    unless ($c->objectAccess("domain.roles.manage"));

    my $edition; unless (@errors) {
        $edition  = $c->Q(" SELECT * FROM editions WHERE id=? ", [ $i_edition ])->Hash;
        push @errors, { id => "edition", msg => "Incorrectly filled field"}
            unless ($edition);
    }

    my $page; unless (@errors) {
        $page  = $c->Q(" SELECT * FROM ad_pages WHERE id=? ", [ $i_page ])->Hash;
        push @errors, { id => "page", msg => "Incorrectly filled field"}
            unless ($page);
    }

    my $area = 0;
    my $size_w = 0;
    my $size_h = 0;

    my ($w1, $w2) = split '/', $i_w;
    my ($h1, $h2) = split '/', $i_h;

    $size_w = $w1/$w2;
    $size_h = $h1/$h2;

    $area = $size_w * $size_h * $i_amount;

    unless (@errors) {
        $c->Do("
            INSERT INTO ad_modules
                (
                    id, edition, page,
                    title, description,
                    amount, area,
                    x, y, w, h,
                    width, height, fwidth, fheight,
                    created, updated)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, now(), now());
        ", [
            $id, $edition->{id}, $page->{id},
            $i_title, $i_description,
            $i_amount, $area, $i_x, $i_y, $i_w, $i_h,
            $i_width, $i_height, $i_fwidth, $i_fheight
        ]);
    }

    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors });
}

sub update {
    my $c = shift;

    my $i_id          = $c->param("id");
    my $i_title       = $c->param("title");
    my $i_description = $c->param("description");

    my $i_amount      = $c->param("amount")  // 1;
    my $i_amount0     = $c->param("amount0") // 0;

    my $i_x           = $c->param("x")       // "1/1";
    my $i_y           = $c->param("y")       // "1/1";
    my $i_w           = $c->param("w")       // "1/1";
    my $i_h           = $c->param("h")       // "1/1";

    my $i_width       = $c->param("width")   // 0;
    my $i_height      = $c->param("height")  // 0;
    my $i_fwidth      = $c->param("fwidth")  // 0;
    my $i_fheight     = $c->param("fheight") // 0;

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
            UPDATE ad_modules SET
                title=?, description=?,
                amount=?, area=?,
                x=?, y=?, w=?, h=?,
                width=?, height=?, fwidth=?, fheight=?,
                updated=now()
            WHERE id =?;
        ", [
                $i_title, $i_description,
                $i_amount, $area,
                $i_x, $i_y, $i_w, $i_h,
                $i_width, $i_height, $i_fwidth, $i_fheight,
                $i_id ]);
    }

    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors });
}

sub delete {
    my $c = shift;
    my @ids = $c->param("id");

    my @errors;
    my $success = $c->json->false;

    #push @errors, { id => "access", msg => "Not enough permissions"}
    #    unless ($c->objectAccess("domain.roles.manage"));

    unless (@errors) {
        foreach my $id (@ids) {
            if ($c->is_uuid($id)) {
                $c->Do(" DELETE FROM ad_modules WHERE id=? ", [ $id ]);
            }
        }
    }

    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors });
}

1;
