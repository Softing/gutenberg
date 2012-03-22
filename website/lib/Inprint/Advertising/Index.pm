package Inprint::Advertising::Index;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use utf8;
use strict;
use warnings;

use base 'Mojolicious::Controller';

sub save {
    my $c = shift;

    my $i_edition   = $c->param("edition");
    my $i_place    = $c->param("place");
    my $i_type = $c->param("type");
    my @i_ids  = $c->param("entity");

    my @errors;
    my $success = $c->json->false;

    push @errors, { id => "edition", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_edition));

    push @errors, { id => "type", msg => "Incorrectly filled field"}
        unless ($i_type ~~ [ "headline", "module" ]);

    my $edition; unless (@errors) {
        $edition  = $c->Q(" SELECT * FROM editions WHERE id=? ", [ $i_edition ])->Hash;
        push @errors, { id => "edition", msg => "Incorrectly filled field"}
            unless ($edition);
    }

    push @errors, { id => "place", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_place));

    my $place; unless (@errors) {
        $place = $c->Q(" SELECT * FROM ad_places WHERE id=? ", [ $i_place ])->Hash;
        push @errors, { id => "place", msg => "Can't find object"}
            unless ($place);
    }

    unless (@errors) {

        $c->Do("
                DELETE FROM ad_index WHERE edition=? AND place=? AND nature=?
            ", [ $edition->{id}, $place->{id}, $i_type ]);

        foreach my $item (@i_ids) {

            next unless ($c->is_uuid($item));

            $c->Do("
                INSERT INTO ad_index(edition, place, nature, entity, created, updated)
                    VALUES (?, ?, ?, ?, now(), now());
            ", [ $edition->{id}, $place->{id}, $i_type, $item ]);
        }
    }

    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors });
}

sub headlines {

    my $c = shift;

    my $i_edition = $c->param("edition");
    my $i_place   = $c->param("place");

    my $result = [];

    my $sql;
    my @params;
    my @errors;
    my $success = $c->json->false;

    push @errors, { id => "edition", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_edition));

    my $edition; unless (@errors) {
        $edition  = $c->Q(" SELECT * FROM editions WHERE id=? ", [ $i_edition ])->Hash;
        push @errors, { id => "edition", msg => "Incorrectly filled field"}
            unless ($edition);
    }

    my $editions = []; unless (@errors) {
        $editions = $c->Q("
            SELECT id FROM editions WHERE path @> ? order by path asc;
        ", [ $edition->{path} ])->Values;
    }

    push @errors, { id => "place", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_place));

    my $place; unless (@errors) {
        $place = $c->Q(" SELECT * FROM ad_places WHERE id=? ", [ $i_place ])->Hash;
        push @errors, { id => "place", msg => "Can't find object"}
            unless ($place);
    }

    unless (@errors) {
        $sql = "
            SELECT
                t1.id, t1.edition, t1.title, t1.description, t1.created, t1.updated,
                EXISTS(SELECT true FROM ad_index WHERE place=? AND entity=t1.id) as selected
            FROM indx_headlines t1
            WHERE t1.edition=ANY(?)
            ORDER BY t1.title
        ";
        push @params, $place->{id};
        push @params, $editions;
    }

    unless (@errors) {
        $result = $c->Q(" $sql ", \@params)->Hashes;
        $c->render_json( { data => $result } );
    }

    $success = $c->json->true unless (@errors);
    $c->render_json( { success => $success, errors => \@errors, data => $result } );
}

sub modules {

    my $c = shift;

    my $i_edition = $c->param("edition");
    my $i_place   = $c->param("place");

    my $result = [];

    my $sql;
    my @params;
    my @errors;
    my $success = $c->json->false;

    push @errors, { id => "edition", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_edition));

    my $edition; unless (@errors) {
        $edition  = $c->Q(" SELECT * FROM editions WHERE id=? ", [ $i_edition ])->Hash;
        push @errors, { id => "edition", msg => "Incorrectly filled field"}
            unless ($edition);
    }

    my $editions = []; unless (@errors) {
        $editions = $c->Q("
            SELECT id FROM editions WHERE path @> ? order by path asc;
        ", [ $edition->{path} ])->Values;
    }

    push @errors, { id => "place", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_place));

    my $place; unless (@errors) {
        $place = $c->Q(" SELECT * FROM ad_places WHERE id=? ", [ $i_place ])->Hash;
        push @errors, { id => "place", msg => "Can't find object"}
            unless ($place);
    }

    unless (@errors) {
        $sql = "
            SELECT
                t1.id, t1.edition, t1.page, t1.title, t1.description, t1.amount, round(t1.area::numeric, 2) as area, t1.x, t1.y, t1.w, t1.h, t1.created, t1.updated,
                t2.id as page, t2.title as page_title,
                EXISTS(SELECT true FROM ad_index WHERE place=? AND entity=t1.id) as selected
            FROM ad_modules t1, ad_pages t2
            WHERE t1.edition= ANY(?) AND t2.id = t1.page
            ORDER BY t2.title, t1.title
        ";
        push @params, $place->{id};
        push @params, $editions;
    }

    unless (@errors) {
        $result = $c->Q(" $sql ", \@params)->Hashes;
        $c->render_json( { data => $result } );
    }

    $success = $c->json->true unless (@errors);
    $c->render_json( { success => $success, errors => \@errors, data => $result } );
}

1;
