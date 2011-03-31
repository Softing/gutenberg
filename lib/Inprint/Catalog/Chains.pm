package Inprint::Catalog::Chains;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use base 'Inprint::BaseController';

sub combo {
    my $c = shift;
    my $result = $c->Q("
            SELECT t1.id, t1.name, t1.shortcut, t1.description,
                t2.shortcut as catalog_shortcut
            FROM chains t1, catalog t2
            WHERE t1.catalog = t2.id
            ORDER BY t1.shortcut
        "
    )->Hashes;

    $c->render_json( { data => $result } );
}

sub create {

    my $c = shift;

    my $i_path        = $c->param("path");
    my $i_name	      = $c->param("name");
    my $i_shortcut    = $c->param("shortcut");
    my $i_description = $c->param("description");

    my $result = {
        errors => []
    };

    # Check input
    push @{ $result->{errors} }, { id => "path", msg => "" }
        unless $i_path;

    push @{ $result->{errors} }, { id => "name", msg => "" }
        unless $i_name;

    push @{ $result->{errors} }, { id => "shortcut", msg => "" }
        unless $i_shortcut;

    # Process request
    unless (@{ $result->{errors} }) {

        $result->{success} = $c->json->true;

        my $id = $c->uuid();

        $c->Do("
            INSERT INTO chains (id, catalog, name, shortcut, description)
                VALUES (?,?,?,?,?)
        ", [ $id, $i_path, $i_name, $i_shortcut, $i_description ]);

    }

    $c->render_json( $result );
}

sub read {
    my $c = shift;
    my $i_id = $c->param("id");
    my $result = $c->Q("
        SELECT t1.*, t2.id as catalog_id, t2.shortcut as catalog_shortcut
        FROM chains t1, catalog t2
        WHERE t1.id=? AND t2.id = t1.catalog
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

        $c->Do("
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
        $c->Do(" DELETE FROM chains WHERE id=? ", [ $id ]);
    }
    $c->render_json( { success => $c->json->true } );
}



1;
