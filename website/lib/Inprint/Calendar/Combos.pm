package Inprint::Calendar::Combos;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use base 'Mojolicious::Controller';

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
            AND t1.enabled = true
            AND t1.deleted = false
            AND t1.archived = false
            AND t2.id = t1.edition
    ";

    my $bindings = $c->objectBindings([
        "editions.attachment.manage:*" ]);

    my $paths = $c->Q("
        SELECT id FROM editions
        WHERE path @> ARRAY(
            SELECT path FROM editions WHERE id = ANY(\$1)
        )", [ $bindings ])->Values;

    $sql .= " AND edition = ANY(?) ";
    push @data, $paths;

    my $result = $c->Q("
        $sql
        ORDER BY t2.shortcut, t1.shortcut
    ", \@data)->Hashes;

    $success = $c->json->true unless (@errors);
    $c->render_json( { data => $result } );
}

#sub childrens {
#    my $c = shift;
#
#    my @errors;
#
#    my $i_edition = $c->get_uuid(\@errors, "edition");
#
#    my @data;
#    my $sql = "
#        SELECT
#            t1.id, t1.shortcut, t1.description
#        FROM editions t1
#        WHERE 1=1
#    ";
#
#    my $childrens = $c->objectChildren("editions", $i_edition, "editions.attachment.manage:*");
#
#    #my $bindings = $c->objectBindings([
#    #    "editions.attachment.manage:*" ]);
#
#    #my $paths = $c->Q("
#    #    SELECT id FROM editions
#    #    WHERE path @> ARRAY(
#    #        SELECT path FROM editions WHERE id = ANY(\$1)
#    #    )", [ $bindings ])->Values;
#
#    $sql .= " AND edition = ANY(?) ";
#    push @data, $childrens;
#
#    my $result = $c->Q("
#        $sql ORDER BY t1.shortcut ",
#        \@data)->Hashes;
#
#    $c->smart_render(\@errors, $result );
#}

sub copyfrom {
    my $c = shift;

    my @errors;
    my $success = $c->json->false;

    my @data;
    my $sql = "
        SELECT
            t1.id, t2.shortcut || '/' || t1.shortcut as title,
            'puzzle' as icon
        FROM fascicles t1, editions t2
        WHERE
            (
                t1.id <> '00000000-0000-0000-0000-000000000000'
                AND t1.id <> '99999999-9999-9999-9999-999999999999' )

            AND t2.id = t1.edition
            AND t1.deleted  = false
            --AND t1.archived = false
            AND t1.fastype  = 'issue'
    ";

    my $access = $c->objectBindings("editions.fascicle.manage:*");
    $sql .= " AND edition = ANY(?) ";
    push @data, $access;

    my $result = $c->Q("
        $sql ORDER BY t1.release_date DESC ",
        \@data)->Hashes;

    unshift @$result, {
        id=> "00000000-0000-0000-0000-000000000000",
        icon => "puzzle",
        title=> $c->l("Defaults"),
        shortcut=> $c->l("Get defaults")
    };

    $success = $c->json->true unless (@errors);
    $c->render_json( { data => $result } );
}

#sub sources {
#    my $c = shift;
#
#    my @errors;
#    my $success = $c->json->false;
#
#    my @data;
#    my $sql = "
#        SELECT
#            t1.id, t2.shortcut || '/' || t1.shortcut as title,
#            'puzzle' as icon
#        FROM fascicles t1, editions t2
#        WHERE
#            ( t1.id <> '00000000-0000-0000-0000-000000000000' AND t1.id <> '99999999-9999-9999-9999-999999999999')
#            AND t2.id = t1.edition
#            AND t1.fastype = 'template'
#    ";
#
#    my $access = $c->objectBindings("editions.fascicle.manage:*");
#    $sql .= " AND edition = ANY(?) ";
#    push @data, $access;
#
#    my $result = $c->Q("
#        $sql
#        ORDER BY t2.shortcut, t1.shortcut
#    ", \@data)->Hashes;
#
#    unshift @$result, {
#        id=> "00000000-0000-0000-0000-000000000000",
#        icon => "puzzle",
#        title=> $c->l("Defaults"),
#        shortcut=> $c->l("Get defaults")
#    };
#
#    $success = $c->json->true unless (@errors);
#    $c->render_json( { data => $result } );
#}

sub templates {
    my $c = shift;

    my @errors;
    my $success = $c->json->false;

    my @data;
    my $result;

    my $sql = "
        SELECT
            t1.id, t2.shortcut || '/' || t1.shortcut as title,
            'puzzle' as icon
        FROM
            template t1,
            editions t2
        WHERE 1=1
            AND t1.id <> '00000000-0000-0000-0000-000000000000'
            AND t1.deleted = false
            AND t2.id = t1.edition
    ";

    my $access = $c->objectBindings(["editions.template.view:*", "editions.template.manage:*"]);

    $sql .= " AND t1.edition = ANY(?) ";
    push @data, $access;

    $result = $c->Q("
        $sql ORDER BY t2.shortcut, t1.shortcut ",
        \@data
        )->Hashes;

    unshift @$result, {
        id=> "00000000-0000-0000-0000-000000000000",
        icon => "leaf",
        title => $c->l("Default"),
        description => $c->l("Default template")
    };

    $success = $c->json->true unless (@errors);
    $c->render_json( { data => $result } );
}

1;
