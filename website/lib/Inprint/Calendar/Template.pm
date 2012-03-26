package Inprint::Calendar::Template;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use Inprint::Models::Fascicle;

use base 'Mojolicious::Controller';

sub read {
    my $c = shift;

    my @params;
    my @errors;
    my $result = [];

    my $i_id = $c->get_uuid(\@errors, "id");

    unless (@errors) {

        my $sql = "
            SELECT
                t1.id,
                t2.id as edition, t2.shortcut as edition_shortcut,
                t1.shortcut, t1.description,
                to_char(t1.created, 'YYYY-MM-DD HH24:MI:SS') as created,
                to_char(t1.updated, 'YYYY-MM-DD HH24:MI:SS') as updated
            FROM template t1, editions t2
            WHERE 1=1
                AND t1.id = ?
        ";

        push @params, $i_id;

        $result = $c->Q($sql, \@params)->Hash;
    }

    $c->smart_render(\@errors, $result);
}

sub list {
    my $c = shift;

    my @params;
    my @errors;
    my $result = [];

    my $i_edition = $c->get_uuid(\@errors, "edition");

    unless (@errors) {

        my $sql = "
            SELECT
                t1.id,
                t2.id as edition, t2.shortcut as edition_shortcut,
                t1.shortcut, t1.description,
                'template' as fastype,
                to_char(t1.created, 'YYYY-MM-DD HH24:MI:SS') as created,
                to_char(t1.updated, 'YYYY-MM-DD HH24:MI:SS') as updated
            FROM template t1, editions t2
            WHERE 1=1
                AND t2.id=t1.edition
                AND t1.deleted = false
                AND t1.edition = ANY(?)
            ORDER BY t1.shortcut DESC
        ";

        my $children  = $c->objectChildren("editions", $i_edition, "editions.template.manage:*");

        push @params, $children;

        $result = $c->Q($sql, \@params)->Hashes;

    }

    $c->smart_render(\@errors, $result);
}

sub create {
    my $c = shift;

    my @params;
    my @errors;
    my $result = [];

    my $i_edition     = $c->get_uuid(\@errors, "edition");
    my $i_shortcut    = $c->get_text(\@errors, "shortcut");
    my $i_description = $c->get_text(\@errors, "description", 1);

    unless (@errors) {
        my $sql = "
            INSERT INTO template (
                edition,
                shortcut, description,
                created, updated)
            VALUES (
                ?,
                ?, ?,
                now(), now()); ";

        push @params, $i_edition;
        push @params, $i_shortcut;
        push @params, $i_description;

        $result = $c->Do($sql, \@params);
    }

    $c->smart_render(\@errors, $result);
}

sub update {
    my $c = shift;

    my @params;
    my @errors;
    my $result = [];

    my $i_id          = $c->get_uuid(\@errors, "id");
    my $i_shortcut    = $c->get_text(\@errors, "shortcut");
    my $i_description = $c->get_text(\@errors, "description", 1);

    unless (@errors) {

        my $sql = "
            UPDATE template
            SET shortcut=?, description=?
            WHERE id=? ";

        push @params, $i_shortcut;
        push @params, $i_description;
        push @params, $i_id;

        $result = $c->Do($sql, \@params);
    }

    $c->smart_render(\@errors, $result);
}


sub remove {
    my $c = shift;

    my @params;
    my @errors;
    my $result = [];

    my $i_id = $c->get_uuid(\@errors, "id");

    unless (@errors) {
        #my $sql = " UPDATE template SET deleted=true WHERE id=? ";
        #push @params, $i_id;
        #$result = $c->Do($sql, \@params);

        push @params, $i_id;
        $result = $c->Do(" DELETE FROM template_page WHERE template=? ", \@params);
        $result = $c->Do(" DELETE FROM template WHERE id=? ", \@params);
    }

    $c->smart_render(\@errors, $result);
}

1;
