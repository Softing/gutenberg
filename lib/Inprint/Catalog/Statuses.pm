package Inprint::Catalog::Statuses;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use base 'Inprint::BaseController';

sub list {
    my $c = shift;
    my $result = $c->sql->Q("
        SELECT id, color, weight as percent, title, shortcut, description, created, updated
        FROM statuses ORDER BY weight, shortcut;
    ")->Hashes;
    $c->render_json( { data => $result } );
}

sub create {
    my $c = shift;

    my $id            = $c->uuid();

    my $i_title       = $c->param("title");
    my $i_shortcut    = $c->param("shortcut");
    my $i_description = $c->param("description");
    my $i_color       = $c->param("color");
    my $i_percent     = $c->param("percent");

    my $result = {
        success => $c->json->false,
        errors => []
    };

    push @{ $result->{errors} }, { id => "title", msg => "" } unless $i_title;
    push @{ $result->{errors} }, { id => "shortcut", msg => "" } unless $i_shortcut;
    push @{ $result->{errors} }, { id => "color", msg => "" } unless $i_color;
    push @{ $result->{errors} }, { id => "percent", msg => "" } unless $i_percent;

    my $count = 0;

    unless (@{ $result->{errors} }) {
        $count = $c->sql->Do("
            INSERT INTO statuses(
                id, color, weight, title, shortcut, description, created, updated)
            VALUES (?, ?, ?, ?, ?, ?, now(), now());
        ", [ $id, $i_color, $i_percent, $i_title, $i_shortcut, $i_description ]);
    }

    $result->{success} = $c->json->true if $count;

    $c->render_json( $result );
}


sub read {
    my $c = shift;
    my $i_id = $c->param("id");
    my $result = {
        success => $c->json->false,
        errors => []
    };
    push @{ $result->{errors} }, { id => "id", msg => "" } unless $i_id;
    $result->{data} = $c->sql->Q("
        SELECT id, color, weight as percent, title, shortcut, description, created, updated
        FROM statuses
        WHERE id=?
    ", [ $i_id ])->Hash;
    $result->{success} = $c->json->true if $result->{data};
    $c->render_json( $result );
}

sub update {
    my $c = shift;

    my $i_id          = $c->param("id");
    my $i_title       = $c->param("title");
    my $i_shortcut    = $c->param("shortcut");
    my $i_description = $c->param("description");
    my $i_color       = $c->param("color");
    my $i_percent     = $c->param("percent");

    my $result = {
        success => $c->json->false,
        errors => []
    };

    push @{ $result->{errors} }, { id => "id", msg => "" } unless $i_id;
    push @{ $result->{errors} }, { id => "title", msg => "" } unless $i_title;
    push @{ $result->{errors} }, { id => "shortcut", msg => "" } unless $i_shortcut;
    push @{ $result->{errors} }, { id => "color", msg => "" } unless $i_color;
    push @{ $result->{errors} }, { id => "percent", msg => "" } unless $i_percent;

    my $path;
    my $count = 0;

    unless (@{ $result->{errors} }) {
        $count = $c->sql->Do("
            UPDATE statuses SET color=?, weight=?, title=?, shortcut=?, description=?
            WHERE id=? ",
        [ $i_color, $i_percent, $i_title, $i_shortcut, $i_description, $i_id ]);
    }

    $result->{success} = $c->json->true if $count;

    $c->render_json( $result );
}

sub delete {
    my $c = shift;
    my @i_ids = $c->param("id");

    foreach my $id (@i_ids) {
        $c->sql->Do(" DELETE FROM statuses WHERE id =? ", [ $id ]);
    }

    $c->render_json( { } );
}

1;
