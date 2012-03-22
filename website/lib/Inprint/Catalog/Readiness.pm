package Inprint::Catalog::Readiness;

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

    my @errors;
    my $result = [];

    my $i_id = $c->get_uuid(\@errors, "id");

    unless (@errors) {
        $result = $c->Q("
            SELECT id, color, weight as percent, title, shortcut, description, created, updated
            FROM readiness
            WHERE id=?
        ", [ $i_id ])->Hash;
    }

    $c->smart_render( \@errors, $result );
}

sub list {
    my $c = shift;

    my @errors;

    my $result = $c->Q("
        SELECT id, color, weight as percent, title, shortcut, description, created, updated
        FROM readiness ORDER BY weight, shortcut;
    ")->Hashes;

    $c->smart_render( \@errors, $result );
}

sub create {
    my $c = shift;

    my @errors;

    my $id            = $c->uuid();

    my $i_title       = $c->get_text(\@errors, "shortcut");
    my $i_shortcut    = $c->get_text(\@errors, "shortcut");
    my $i_description = $c->get_text(\@errors, "description", 1);
    my $i_color       = $c->get_text(\@errors, "color");
    my $i_percent     = $c->get_int(\@errors, "percent");

    $c->check_access( \@errors, "domain.readiness.manage");

    unless (@errors) {
        $c->Do("
            INSERT INTO readiness (
                id, color, weight, title, shortcut, description, created, updated)
            VALUES (?, ?, ?, ?, ?, ?, now(), now());
        ", [ $id, $i_color, $i_percent, $i_title, $i_shortcut, $i_description ]);
    }

    $c->smart_render(\@errors);
}

sub update {
    my $c = shift;

    my @errors;

    my $i_id          = $c->get_uuid(\@errors, "id");
    my $i_title       = $c->get_text(\@errors, "shortcut");
    my $i_shortcut    = $c->get_text(\@errors, "shortcut");
    my $i_description = $c->get_text(\@errors, "description", 1);
    my $i_color       = $c->get_text(\@errors, "color");
    my $i_percent     = $c->get_int(\@errors, "percent");

    $c->check_access( \@errors, "domain.readiness.manage");

    unless (@errors) {
        $c->Do("
            UPDATE readiness SET color=?, weight=?, title=?, shortcut=?, description=?
            WHERE id=? ",
        [ $i_color, $i_percent, $i_title, $i_shortcut, $i_description, $i_id ]);
    }

    $c->smart_render(\@errors);
}

sub delete {
    my $c = shift;

    my @errors;

    my @i_ids = $c->param("id");

    foreach (@i_ids) {
        $c->check_uuid(\@errors, "id", $_);
    }

    $c->check_access( \@errors, "domain.readiness.manage");

    unless (@errors) {
        foreach my $id (@i_ids) {
            $c->Do(" DELETE FROM readiness WHERE id =? ", [ $id ]);
        }
    }

    $c->smart_render(\@errors);
}

1;
