package Inprint::Catalog::Stages;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use utf8;
use strict;
use warnings;

use base 'Inprint::BaseController';

sub read {
    my $c = shift;
    my $i_id = $c->param("id");
    
    my @errors;
    my $success = $c->json->false;

    push @errors, { id => "id", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_id));
    
    my $result = [];
    
    unless (@errors) {
        $result = $c->sql->Q(" SELECT id, branch, readiness, weight, title, shortcut, description FROM stages WHERE id=? ", [ $i_id ])->Hash;
    }
    
    $success = $c->json->true unless (@errors);
    
    $c->render_json( { success => $success, errors => \@errors, data => $result } );
}

sub list {

    my $c = shift;

    my $i_edition = $c->param("branch");

    my @errors;
    my $success = $c->json->false;

    push @errors, { id => "branch", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_edition));
    
    my $result = [];

    unless (@errors) {
        
        my $idBranch = $c->sql->Q("
            SELECT id FROM branches WHERE edition=? LIMIT 1
        ", [$i_edition])->Value;
    
        $result = $c->sql->Q("
            SELECT t1.id, t1.branch, t1.readiness, t1.weight, t1.title, t1.shortcut, t1.description,
                t2.shortcut as readiness_shortcut, t2.color as readiness_color
            FROM stages t1, readiness t2
            WHERE t1.branch=? AND t1.readiness=t2.id
            ORDER BY t1.weight, t1.shortcut
        ", [ $idBranch ])->Hashes;
    
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
    }

    $success = $c->json->true unless (@errors);
    
    $c->render_json( { success => $success, errors => \@errors, data => $result } );
}

sub create {

    my $c = shift;

    my $id = $c->uuid();

    my $i_edition      = $c->param("branch");
    my $i_readiness   = $c->param("readiness");
    my $i_weight      = $c->param("weight");

    my $i_title       = $c->param("title");
    my $i_shortcut    = $c->param("shortcut");
    my $i_description = $c->param("description");
    
    my @errors;
    my $success = $c->json->false;
    
    push @errors, { id => "branch", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_edition));
    
    push @errors, { id => "readiness", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_readiness));
        
    push @errors, { id => "weight", msg => "Incorrectly filled field"}
        unless ($c->is_int($i_weight));
    
    push @errors, { id => "title", msg => "Incorrectly filled field"}
        unless ($c->is_text($i_title));
        
    push @errors, { id => "shortcut", msg => "Incorrectly filled field"}
        unless ($c->is_text($i_shortcut));
        
    push @errors, { id => "description", msg => "Incorrectly filled field"}
        unless ($c->is_text($i_description));
        
    push @errors, { id => "access", msg => "Not enough permissions [domain.exchange.manage]"}
        unless ($c->access->Check("domain.exchange.manage"));

    unless (@errors) {
        
        my $idBranch = $c->sql->Q(" SELECT id FROM branches WHERE edition=? LIMIT 1 ", [$i_edition])->Value;
        
        unless ($idBranch) {
            my $edition = $c->sql->Q(" SELECT * FROM editions WHERE edition=? ", [$i_edition])->Hash;
            $c->sql->Do("
                INSERT INTO branches(edition, mtype, title, shortcut, description, created, updated)
                VALUES (?, ?, ?, ?, ?, now(), now());
             ", [ $edition->{id}, "document", $edition->{title}, $edition->{shortcut}, $edition->{description} ])->Value;
            $idBranch = $c->sql->Q(" SELECT id FROM branches WHERE edition=? LIMIT 1 ", [$i_edition])->Value;
        }
        
        push @errors, { id => "access", msg => "Not enough permissions <$idBranch>"}
            unless ($c->is_uuid($idBranch));
        
        unless (@errors) {
            $c->sql->Do("
                INSERT INTO stages (id, branch, readiness, weight, title, shortcut, description)
                    VALUES (?,?,?,?,?,?,?)
            ", [ $id, $idBranch, $i_readiness, $i_weight, $i_title, $i_shortcut, $i_description ]);
        }
    }
    
    $success = $c->json->true unless (@errors);
    
    $c->render_json({ success => $success, errors => \@errors });
}

sub update {
    my $c = shift;

    my $i_id          = $c->param("id");

    my $i_readiness   = $c->param("readiness");
    my $i_weight      = $c->param("weight");

    my $i_title       = $c->param("title");
    my $i_shortcut    = $c->param("shortcut");
    my $i_description = $c->param("description");

    my @errors;
    my $success = $c->json->false;
    
    push @errors, { id => "id", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_id));
    
    push @errors, { id => "readiness", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_readiness));
        
    push @errors, { id => "weight", msg => "Incorrectly filled field"}
        unless ($c->is_int($i_weight));
    
    push @errors, { id => "title", msg => "Incorrectly filled field"}
        unless ($c->is_text($i_title));
        
    push @errors, { id => "shortcut", msg => "Incorrectly filled field"}
        unless ($c->is_text($i_shortcut));
        
    push @errors, { id => "description", msg => "Incorrectly filled field"}
        unless ($c->is_text($i_description));
        
    push @errors, { id => "access", msg => "Not enough permissions for [domain.exchange.manage]"}
        unless ($c->access->Check("domain.exchange.manage"));

    unless (@errors) {
        $c->sql->Do("
            UPDATE stages
                SET readiness=?, weight=?, title=?, shortcut=?, description=?, updated=now()
            WHERE id =?;
        ", [ $i_readiness, $i_weight, $i_title, $i_shortcut, $i_description, $i_id ]);
    }

    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors });
}

sub principalsMapping {
    my $c = shift;

    my $i_stage = $c->param("stage");

    my @errors;
    my $success = $c->json->false;
    
    push @errors, { id => "stage", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_stage));

    my $result = [];
    
    unless (@errors) {
        $result = $c->sql->Q("
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
    }

    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors, data => $result });
}

sub mapPrincipals {
    my $c = shift;

    my $i_stage   = $c->param("stage");
    my $i_catalog = $c->param("catalog");
    my @i_members = $c->param("principals");

    my @errors;
    my $success = $c->json->false;
    
    push @errors, { id => "stage", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_stage));
        
    push @errors, { id => "catalog", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_catalog));
    
    push @errors, { id => "access", msg => "Not enough permissions"}
        unless ($c->access->Check("domain.exchange.manage"));

    unless (@errors) {
        foreach my $member (@i_members) {
            if ($c->is_uuid($member)) {
                $c->sql->Do(" DELETE FROM map_principals_to_stages WHERE stage=? AND catalog=? AND principal=? ", [ $i_stage, $i_catalog, $member ]);
                $c->sql->Do(" INSERT INTO map_principals_to_stages(stage, catalog, principal) VALUES (?, ?, ?) ", [ $i_stage, $i_catalog, $member ]);
            }
        }
    }

    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors });
}

sub unmapPrincipals {
    my $c = shift;

    my @i_members = $c->param("principals");

    my @errors;
    my $success = $c->json->false;
    
    push @errors, { id => "access", msg => "Not enough permissions"}
        unless ($c->access->Check("domain.exchange.manage"));

    unless (@errors) {
        foreach my $member (@i_members) {
            if ($c->is_uuid($member)) {
                $c->sql->Do(" DELETE FROM map_principals_to_stages WHERE id=? ", [ $member ]);
            }
        }
    }

    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors });
}


sub delete {
    my $c = shift;
    my @ids = $c->param("id");

    my @errors;
    my $success = $c->json->false;
    
    push @errors, { id => "access", msg => "Not enough permissions"}
        unless ($c->access->Check("domain.exchange.manage"));

    unless (@errors) {
        foreach my $id (@ids) {
            if ($c->is_uuid($id)) {
                $c->sql->Do(" DELETE FROM stages WHERE id=? ", [ $id ]);
            }
        }
    }
    
    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors });
}



1;
