package Inprint::Advertising::Combo;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use utf8;
use strict;
use warnings;

use base 'Mojolicious::Controller';

sub managers {
    my $c = shift;

    my $i_edition  = $c->param("edition") || undef;
    my $i_fascicle = $c->param("fascicle") || undef;

    my $i_query = $c->param("query") || undef;

    my @errors;
    my $success = $c->json->false;

    push @errors, { id => "query", msg => "Incorrectly filled field"}
        if (length $i_query < 2);

    my $result;

    unless(@errors){
        $result = $c->Q("
            SELECT DISTINCT
                t1.id, t1.shortcut as title, t1.description as description, 'user' as icon
            FROM view_principals t1, map_member_to_catalog t2
            WHERE
                t2.member = t1.id
                AND t1.type = 'member'
                AND t1.shortcut ILIKE ?
        ",[ "%$i_query%" ])->Hashes;
    }

    $c->render_json( { data => $result || [] } );
}

sub advertisers {

    my $c = shift;

    my @data;
    my @errors;

    my $i_edition  = $c->param("edition")  || undef;
    my $i_fascicle = $c->param("fascicle") || undef;
    my $i_query    = $c->param("query")    || undef;

    if ($i_query && length $i_query < 2) {
        push @errors, { id => "query", msg => "Incorrectly filled field"};
    }

    my $edition_id;

    if ($i_edition) {
        $edition_id = $c->Q(" SELECT id FROM editions WHERE id=? ", $i_edition)->Value;
    }

    if ($i_fascicle) {
        $edition_id = $c->Q(" SELECT edition FROM fascicles WHERE id=? ", $i_fascicle)->Value;
    }

    my $sql = "
        SELECT
            t1.id,
            'user-silhouette' as icon,
            t2.shortcut || ' - ' || t1.shortcut as title
        FROM ad_advertisers t1, editions t2
        WHERE t1.edition = t2.id ";

    if ($edition_id) {
        my $editions = $c->objectParents("editions", $edition_id, "editions.advert.view:*");
        $sql .= " AND t1.edition = ANY(?)";
        push @data, $editions;
    }

    if ($i_query) {
        $sql .= " AND t1.title ILIKE ? ";
        push @data, "%$i_query%";
    }

    my $result;
    unless(@errors){
        $result = $c->Q($sql, \@data)->Hashes;
    }

    @$result = sort { $a->{title} cmp $b->{title} } @$result;

    $c->smart_render( \@errors, $result );
}

sub fascicles {
    my $c = shift;

    my $i_edition  = $c->param("edition") || undef;
    my $i_fascicle = $c->param("fascicle") || undef;
    my $i_term = $c->param("term") || undef;

    my @errors;
    my $success = $c->json->false;

    my @data;
    my $sql = "
        SELECT t1.id, t2.shortcut || '/' || t1.shortcut as title, t1.shortcut, t1.description, 'blue-folder' as icon
        FROM fascicles t1, editions t2
        WHERE t2.id = t1.edition AND is_system = false AND is_enabled = true
    ";

    if ($i_term) {
        my $access = $c->objectBindingsByTerm($i_term);
        $sql .= " AND edition = ANY(?) ";
        push @data, $access;
    }

    if ($i_edition) {
        my $editions = $c->Q(" SELECT id FROM editions WHERE path ~ ('*.' || replace(?, '-', '')::text || '.*')::lquery ", [$i_edition])->Values;
        $sql .= " AND edition = ANY(?)";
        push @data, $editions;
    }

    my $result = $c->Q("
        $sql
        ORDER BY is_enabled DESC, t2.shortcut, t1.shortcut
    ", \@data)->Hashes;
    $c->render_json( { data => $result } );
}

sub places {
    my $c = shift;

    my $i_fascicle = $c->param("fascicle") || undef;

    my $result = $c->Q("
        SELECT id, title
        FROM fascicles_tmpl_places WHERE fascicle=?
        ORDER BY title
    ", [ $i_fascicle ])->Hashes;
    $c->render_json( { data => $result } );

}

sub modules {
    my $c = shift;

    my $i_place = $c->param("place") || undef;

    my $result = $c->Q("
        SELECT t1.id, t1.shortcut as title
        FROM fascicles_tmpl_modules t1, fascicles_tmpl_index t2
        WHERE t2.entity=t1.id AND t2.nature='module' AND t2.place=?
        ORDER BY title
    ", [ $i_place ])->Hashes;

    $c->render_json( { data => $result } );
}

1;
