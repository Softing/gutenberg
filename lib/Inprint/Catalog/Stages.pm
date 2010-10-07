package Inprint::Catalog::Stages;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use base 'Inprint::BaseController';

sub list {

    my $c = shift;

    my $i_branch = $c->param("branch");

    my $result = $c->sql->Q("
        SELECT t1.id, t1.branch, t1.readiness, t1.weight, t1.title, t1.shortcut, t1.description,
            t2.shortcut as readiness_shortcut, t2.color as readiness_color
        FROM stages t1, readiness t2
        WHERE t1.branch=? AND t1.readiness=t2.id
        ORDER BY t1.weight, t1.shortcut
    ", [ $i_branch ])->Hashes;

    foreach my $stage (@$result) {

        $stage->{members} = $c->sql->Q("
            SELECT t1.id, t1.stage, t1.catalog, t1.principal,
                t2.shortcut as catalog_shortcut,
                t3.shortcut as stage_shortcut,
                t4.type,
                t4.shortcut as title,
                t4.description
            FROM map_principals_to_stages t1, catalog t2, stages t3, view_principals t4
            WHERE stage=?
                AND t1.catalog = t2.id
                AND t1.stage = t3.id
                AND t1.principal = t4.id
            ORDER BY t4.type, t4.shortcut 
        ", [ $stage->{id} ])->Hashes;

    }

    $c->render_json( { data => $result } );
}

sub create {

    my $c = shift;

    my $i_branch      = $c->param("branch");
    my $i_readiness   = $c->param("readiness");
    my $i_weight      = $c->param("weight");

    my $i_title       = $c->param("title");
    my $i_shortcut    = $c->param("shortcut");
    my $i_description = $c->param("description");

    my $result = {
        errors => []
    };

    # Check input
    push @{ $result->{errors} }, { id => "branch", msg => "" }
        unless $i_branch;
    push @{ $result->{errors} }, { id => "readiness", msg => "" }
        unless $i_readiness;
    push @{ $result->{errors} }, { id => "weight", msg => "" }
        unless $i_weight;
    push @{ $result->{errors} }, { id => "title", msg => "" }
        unless $i_title;
    push @{ $result->{errors} }, { id => "shortcut", msg => "" }
        unless $i_shortcut;

    # Process request
    unless (@{ $result->{errors} }) {
        $result->{success} = $c->json->true;
        my $id = $c->uuid();
        $c->sql->Do("
            INSERT INTO stages (id, branch, readiness, weight, title, shortcut, description)
                VALUES (?,?,?,?,?,?,?)
        ", [ $id, $i_branch, $i_readiness, $i_weight, $i_title, $i_shortcut, $i_description ]);
    }

    $c->render_json( $result );
}

sub read {
    my $c = shift;
    my $i_id = $c->param("id");
    my $result = $c->sql->Q("
        SELECT id, branch, readiness, weight, title, shortcut, description
        FROM stages
        WHERE id=?
    ", [ $i_id ])->Hash;
    $c->render_json( { success => $c->json->true, data => $result } );
}

sub update {
    my $c = shift;

    my $i_id          = $c->param("id");

    my $i_readiness   = $c->param("readiness");
    my $i_weight      = $c->param("weight");

    my $i_title       = $c->param("title");
    my $i_shortcut    = $c->param("shortcut");
    my $i_description = $c->param("description");

    my $result = {
        errors => []
    };

    # Check input
    push @{ $result->{errors} }, { id => "id", msg => "" }
        unless $i_id;

    # Check input
    #push @{ $result->{errors} }, { id => "branch", msg => "" }
    #    unless $i_branch;
    push @{ $result->{errors} }, { id => "readiness", msg => "" }
        unless $i_readiness;
    push @{ $result->{errors} }, { id => "weight", msg => "" }
        unless $i_weight;
    push @{ $result->{errors} }, { id => "title", msg => "" }
        unless $i_title;
    push @{ $result->{errors} }, { id => "shortcut", msg => "" }
        unless $i_shortcut;

    # Process request
    unless (@{ $result->{errors} }) {
        $result->{success} = $c->json->true;
        $c->sql->Do("
            UPDATE stages
                SET readiness=?, weight=?, title=?, shortcut=?, description=?, updated=now()
            WHERE id =?;
        ", [ $i_readiness, $i_weight, $i_title, $i_shortcut, $i_description, $i_id ]);
    }

    $c->render_json( $result );
}

sub principalsMapping {
    my $c = shift;

    my $i_stage = $c->param("stage");

    my $result = $c->sql->Q("
        SELECT t1.id, t1.stage, t1.catalog, t1.principal,
            t2.shortcut as catalog_shortcut,
            t3.shortcut as stage_shortcut,
            t4.type,
            t4.shortcut as title,
            t4.description
        FROM map_principals_to_stages t1, catalog t2, stages t3, view_principals t4
        WHERE stage=?
            AND t1.catalog = t2.id
            AND t1.stage = t3.id
            AND t1.principal = t4.id
        ORDER BY t4.type, t4.shortcut
    ", [ $i_stage ])->Hashes;

    $c->render_json( { data => $result } );
}

sub mapPrincipals {
    my $c = shift;

    my $i_stage   = $c->param("stage");
    my $i_catalog = $c->param("catalog");
    my @i_members = $c->param("principals");

    foreach my $item (@i_members) {
        $c->sql->Do(" DELETE FROM map_principals_to_stages WHERE stage=? AND catalog=? AND principal=? ", [ $i_stage, $i_catalog, $item ]);
        $c->sql->Do(" INSERT INTO map_principals_to_stages(stage, catalog, principal) VALUES (?, ?, ?); ", [ $i_stage, $i_catalog, $item ]);
    }

    $c->render_json( { success => $c->json->true } );
}

sub unmapPrincipals {
    my $c = shift;

    my @i_members = $c->param("principals");

    foreach my $item (@i_members) {
        $c->sql->Do(" DELETE FROM map_principals_to_stages WHERE id=? ", [ $item ]);
    }

    $c->render_json( { success => $c->json->true } );
}


sub delete {
    my $c = shift;
    my @ids = $c->param("id");
    foreach my $id (@ids) {
        $c->sql->Do(" DELETE FROM stages WHERE id=? ", [ $id ]);
    }
    $c->render_json( { success => $c->json->true } );
}



1;
