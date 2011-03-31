package Inprint::Calendar::Combos;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use base 'Inprint::BaseController';

sub editions {
    my $c = shift;

    my $filter = $c->param("parent");

    my @params;
    my $sql = "
        SELECT t1.id, t1.shortcut as title, nlevel(path) as nlevel, description,
            array_to_string( ARRAY( SELECT shortcut FROM editions WHERE path @> t1.path ORDER BY nlevel(path) ), '.') as title_path
        FROM editions t1 WHERE 1=1
    ";

    if ($filter) {
        $sql .= " AND t1.path ~ ('*.' || replace(?, '-', '')::text || '.*')::lquery ";
        push @params, $filter;
    }

    $sql .= " ORDER BY title_path ";

    my $result = $c->Q($sql, \@params)->Hashes;
    $c->render_json( { data => $result } );
}

sub parents {
    my $c = shift;

    my @errors;
    my $success = $c->json->false;

    my @data;
    my $sql = "
        SELECT
            t1.id, t2.shortcut || '/' || t1.shortcut as title, t1.shortcut, t1.description
        FROM fascicles t1, editions t2
        WHERE
            ( t1.id <> '00000000-0000-0000-0000-000000000000' AND t1.id <> '99999999-9999-9999-9999-999999999999')
            AND t1.edition = t1.parent
            AND t1.fastype = 'issue'
            AND t2.id = t1.edition
    ";

    my $access = $c->objectBindings("editions.calendar.manage");
    $sql .= " AND edition = ANY(?) ";
    push @data, $access;

    my $result = $c->Q("
        $sql
        ORDER BY t2.shortcut, t1.shortcut
    ", \@data)->Hashes;

    $success = $c->json->true unless (@errors);
    $c->render_json( { data => $result } );
}

sub sources {
    my $c = shift;

    my @errors;
    my $success = $c->json->false;

    my @data;
    my $sql = "
        SELECT
            t1.id, t2.shortcut || '/' || t1.shortcut as title, t1.shortcut, t1.description
        FROM fascicles t1, editions t2
        WHERE
            ( t1.id <> '00000000-0000-0000-0000-000000000000' AND t1.id <> '99999999-9999-9999-9999-999999999999')
            AND t2.id = t1.edition
            AND t1.fastype = 'template'
    ";

    my $access = $c->objectBindings("editions.calendar.manage");
    $sql .= " AND edition = ANY(?) ";
    push @data, $access;

    my $result = $c->Q("
        $sql
        ORDER BY t2.shortcut, t1.shortcut
    ", \@data)->Hashes;

    #unshift @$result, {
    #    id=> "00000000-0000-0000-0000-000000000000",
    #    icon => "marker",
    #    title=> $c->l("Defaults"),
    #    shortcut=> $c->l("Get defaults"),
    #    description=> $c->l("Copy from defaults"),
    #};

    $success = $c->json->true unless (@errors);
    $c->render_json( { data => $result } );
}

1;
