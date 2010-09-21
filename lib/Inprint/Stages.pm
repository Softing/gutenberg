package Inprint::Stages;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use base 'Inprint::BaseController';

sub list {

    my $c = shift;

    my $i_chain = $c->param("chain");

    my $result = $c->sql->Q("
        SELECT id, chain, color, weight, name, shortcut, description
        FROM stages
        WHERE chain=?
        ORDER BY weight, shortcut
    ", [ $i_chain ])->Hashes;

    $c->render_json( { data => $result } );
}

sub create {

    my $c = shift;

    my $i_chain       = $c->param("chain");
    my $i_color       = $c->param("color");
    my $i_weight      = $c->param("weight");

    my $i_name	      = $c->param("name");
    my $i_shortcut    = $c->param("shortcut");
    my $i_description = $c->param("description");

    my $result = {
        errors => []
    };

    # Check input
    push @{ $result->{errors} }, { id => "chain", msg => "" }
        unless $i_chain;

    push @{ $result->{errors} }, { id => "color", msg => "" }
        unless $i_color;

    push @{ $result->{errors} }, { id => "weight", msg => "" }
        unless $i_weight;

    push @{ $result->{errors} }, { id => "name", msg => "" }
        unless $i_name;

    push @{ $result->{errors} }, { id => "shortcut", msg => "" }
        unless $i_shortcut;

    # Process request
    unless (@{ $result->{errors} }) {

        $result->{success} = $c->json->true;

        my $id = $c->uuid();

        $c->sql->Do("
            INSERT INTO stages (id, chain, color, weight, name, shortcut, description)
                VALUES (?,?,?,?,?,?,?)
        ", [ $id, $i_chain, $i_color, $i_weight, $i_name, $i_shortcut, $i_description ]);

    }

    $c->render_json( $result );
}

sub read {
    my $c = shift;
    my $i_id = $c->param("id");
    my $result = $c->sql->Q("
        SELECT id, color, weight, name, shortcut, description
        FROM stages
        WHERE id=?
    ", [ $i_id ])->Hash;
    $c->render_json( { success => $c->json->true, data => $result } );
}

sub update {
    my $c = shift;

    my $i_id          = $c->param("id");
    my $i_path        = $c->param("path");
    my $i_name        = $c->param("name");
    my $i_shortcut    = $c->param("shortcut");
    my $i_description = $c->param("description");

    my $result = {
        errors => []
    };

    # Check input
    push @{ $result->{errors} }, { id => "id", msg => "" }
        unless $i_id;

    push @{ $result->{errors} }, { id => "path", msg => "" }
        unless $i_path;

    push @{ $result->{errors} }, { id => "name", msg => "" }
        unless $i_name;

    push @{ $result->{errors} }, { id => "shortcut", msg => "" }
        unless $i_shortcut;

    # Process request
    unless (@{ $result->{errors} }) {

        $result->{success} = $c->json->true;

        $c->sql->Do("
            UPDATE chains
                SET catalog=?, name=?, shortcut=?, description=?, updated=now()
            WHERE id =?;
        ", [ $i_path, $i_name, $i_shortcut, $i_description, $i_id ]);
    }

    $c->render_json( $result );
}

sub delete {
    my $c = shift;
    my @ids = $c->param("id");
    foreach my $id (@ids) {
        $c->sql->Do(" DELETE FROM chains WHERE id=? ", [ $id ]);
    }
    $c->render_json( { success => $c->json->true } );
}



1;
