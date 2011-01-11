package Inprint::Fascicle::Templates::Index;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use utf8;
use strict;
use warnings;

use base 'Inprint::BaseController';

sub save {
    my $c = shift;

    my $i_fascicle = $c->param("fascicle");
    my $i_place    = $c->param("place");
    my $i_type     = $c->param("type");
    my @i_ids      = $c->param("entity");

    my @errors;
    my $success = $c->json->false;

    push @errors, { id => "fascicle", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_fascicle));

    my $fascicle; unless (@errors) {
        $fascicle = $c->sql->Q(" SELECT * FROM fascicles WHERE id=? ", [ $i_fascicle ])->Hash;
        push @errors, { id => "facicle", msg => "Can't find object"}
            unless ($fascicle);
    }

    push @errors, { id => "place", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_place));

    my $place; unless (@errors) {
        $place = $c->sql->Q(" SELECT * FROM fascicles_tmpl_places WHERE id=? ", [ $i_place ])->Hash;
        push @errors, { id => "place", msg => "Can't find object"}
            unless ($fascicle);
    }

    push @errors, { id => "type", msg => "Incorrectly filled field"}
        unless ($i_type ~~ [ "headline", "module" ]);

    unless (@errors) {

        $c->sql->Do("
                DELETE FROM fascicles_tmpl_index WHERE fascicle=? AND place=? AND nature=?
            ", [ $fascicle->{id}, $place->{id}, $i_type ]);

        foreach my $item (@i_ids) {

            next unless ($c->is_uuid($item));

            $c->sql->Do("
                INSERT INTO fascicles_tmpl_index(edition, fascicle, place, nature, entity, created, updated)
                    VALUES (?, ?, ?, ?, ?, now(), now());
            ", [ $fascicle->{edition}, $fascicle->{id}, $place->{id}, $i_type, $item ]);

        }
    }

    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors });
}

sub modules {

    my $c = shift;

    my $i_fascicle = $c->param("fascicle");
    my $i_place    = $c->param("place");

    my $result = [];

    my @errors;
    my $success = $c->json->false;

    push @errors, { id => "fascicle", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_fascicle));

    my $fascicle; unless (@errors) {
        $fascicle = $c->sql->Q(" SELECT * FROM fascicles WHERE id=? ", [ $i_fascicle ])->Hash;
        push @errors, { id => "edition", msg => "Can't find object"}
            unless ($fascicle);
    }

    push @errors, { id => "place", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_place));

    my $place; unless (@errors) {
        $place = $c->sql->Q(" SELECT * FROM fascicles_tmpl_places WHERE id=? ", [ $i_place ])->Hash;
        push @errors, { id => "place", msg => "Can't find object"}
            unless ($fascicle);
    }

    my $sql;
    my @params;

    unless (@errors) {
        $sql = "
            SELECT
                t1.id, t1.fascicle, t1.page, t1.title, t1.description, t1.amount,
                round(t1.area::numeric, 2) as area, t1.x, t1.y, t1.w, t1.h, t1.created, t1.updated,
                t2.id as page, t2.title as page_shortcut,
                EXISTS(SELECT true FROM fascicles_tmpl_index WHERE fascicle=t1.fascicle AND place=? AND entity=t1.id) as selected
            FROM fascicles_tmpl_modules t1, fascicles_tmpl_pages t2
            WHERE t2.id = t1.page AND t1.fascicle=?
            ORDER BY t2.title, t1.title
        ";
        push @params, $place->{id};
        push @params, $fascicle->{id};
    }

    unless (@errors) {
        $result = $c->sql->Q(" $sql ", \@params)->Hashes;
        $c->render_json( { data => $result } );
    }

    $success = $c->json->true unless (@errors);
    $c->render_json( { success => $success, errors => \@errors, data => $result } );
}

sub headlines {

    my $c = shift;

    my $i_fascicle = $c->param("fascicle");
    my $i_place    = $c->param("place");

    my $result = [];

    my $sql;
    my @params;
    my @errors;
    my $success = $c->json->false;

    push @errors, { id => "fascicle", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_fascicle));

    my $fascicle; unless (@errors) {
        $fascicle = $c->sql->Q(" SELECT * FROM fascicles WHERE id=? ", [ $i_fascicle ])->Hash;
        push @errors, { id => "edition", msg => "Can't find object"}
            unless ($fascicle);
    }

    push @errors, { id => "place", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_place));

    my $place; unless (@errors) {
        $place = $c->sql->Q(" SELECT * FROM fascicles_tmpl_places WHERE id=? ", [ $i_place ])->Hash;
        push @errors, { id => "place", msg => "Can't find object"}
            unless ($fascicle);
    }

    unless (@errors) {
        $sql = "
            SELECT
                t1.id, t1.edition, t1.title, t1.description, t1.created, t1.updated,
                EXISTS(SELECT true FROM fascicles_tmpl_index WHERE fascicle=t1.fascicle AND place=? AND entity=t1.id) as selected
            FROM fascicles_indx_headlines t1
            WHERE t1.fascicle=?
            ORDER BY t1.title
        ";
        push @params, $place->{id};
        push @params, $fascicle->{id};
    }

    unless (@errors) {
        $result = $c->sql->Q(" $sql ", \@params)->Hashes;
        $c->render_json( { data => $result } );
    }

    $success = $c->json->true unless (@errors);
    $c->render_json( { success => $success, errors => \@errors, data => $result } );
}

1;
