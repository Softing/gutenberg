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

    $c->check_uuid( \@errors, "id", $i_id);

    my $result = [];

    unless (@errors) {
        $result = $c->Q(" SELECT id, branch, readiness, weight, title, shortcut, description FROM stages WHERE id=? ", [ $i_id ])->Hash;
    }

    $success = $c->json->true unless (@errors);

    $c->render_json( { success => $success, errors => \@errors, data => $result } );
}

sub list {

    my $c = shift;

    my $i_edition = $c->param("branch");

    my @errors;
    my $success = $c->json->false;

    $c->check_uuid( \@errors, "id", $i_edition);

    my $result = [];

    unless (@errors) {

        my $idBranch = $c->Q("
            SELECT id FROM branches WHERE edition=? LIMIT 1
        ", [$i_edition])->Value;

        $result = $c->Q("
            SELECT t1.id, t1.branch, t1.readiness, t1.weight, t1.title, t1.shortcut, t1.description,
                t2.shortcut as readiness_shortcut, t2.color as readiness_color
            FROM stages t1, readiness t2
            WHERE t1.branch=? AND t1.readiness=t2.id
            ORDER BY t1.weight, t1.shortcut
        ", [ $idBranch ])->Hashes;

        foreach my $stage (@$result) {
            $stage->{members} = $c->Q("
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

    my $i_edition     = $c->param("branch");
    my $i_readiness   = $c->param("readiness");
    my $i_weight      = $c->param("weight");

    my $i_title       = $c->param("title");
    my $i_shortcut    = $c->param("shortcut");
    my $i_description = $c->param("description");

    my @errors;
    my $success = $c->json->false;

    $c->check_uuid( \@errors, "branch", $i_edition);
    $c->check_uuid( \@errors, "readiness", $i_readiness);
    $c->check_int( \@errors, "weight", $i_weight);
    $c->check_text( \@errors, "title", $i_title);
    $c->check_text( \@errors, "shortcut", $i_shortcut);

    $c->check_access( \@errors, "domain.exchange.manage");

    unless (@errors) {

        my $idBranch = $c->Q(" SELECT id FROM branches WHERE edition=? LIMIT 1 ", [$i_edition])->Value;

        unless ($idBranch) {
            my $edition = $c->Q(" SELECT * FROM editions WHERE id=? ", [$i_edition])->Hash;
            $c->Do("
                INSERT INTO branches(edition, mtype, title, shortcut, description, created, updated)
                VALUES (?, ?, ?, ?, ?, now(), now());
             ", [ $edition->{id}, "document", $edition->{title}, $edition->{shortcut}, $edition->{description} ]);
            $idBranch = $c->Q(" SELECT id FROM branches WHERE edition=? LIMIT 1 ", [$i_edition])->Value;
        }

        push @errors, { id => "access", msg => "Not enough permissions <$idBranch>"}
            unless ($c->is_uuid($idBranch));

        unless (@errors) {
            $c->Do("
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

    $c->check_uuid( \@errors, "id", $i_id);
    $c->check_uuid( \@errors, "readiness", $i_readiness);
    $c->check_int( \@errors, "weight", $i_weight);
    $c->check_text( \@errors, "title", $i_title);
    $c->check_text( \@errors, "shortcut", $i_shortcut);

    $c->check_access( \@errors, "domain.exchange.manage");

    unless (@errors) {
        $c->Do("
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

    $c->check_uuid( \@errors, "stage", $i_stage);

    my $result = [];

    unless (@errors) {
        $result = $c->Q("
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

    $c->check_uuid( \@errors, "stage", $i_stage);
    $c->check_uuid( \@errors, "catalog", $i_catalog);

    $c->check_access( \@errors, "domain.exchange.manage");

    foreach my $member (@i_members) {
        $c->check_uuid( \@errors, "member", $member);
    }

    unless (@errors) {
        foreach my $member (@i_members) {
            $c->Do(" DELETE FROM map_principals_to_stages WHERE stage=? AND catalog=? AND principal=? ", [ $i_stage, $i_catalog, $member ]);
            $c->Do(" INSERT INTO map_principals_to_stages(stage, catalog, principal) VALUES (?, ?, ?) ", [ $i_stage, $i_catalog, $member ]);
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
        unless ($c->objectAccess("domain.exchange.manage"));

    unless (@errors) {
        foreach my $member (@i_members) {
            if ($c->is_uuid($member)) {
                $c->Do(" DELETE FROM map_principals_to_stages WHERE id=? ", [ $member ]);
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
        unless ($c->objectAccess("domain.exchange.manage"));

    unless (@errors) {
        foreach my $id (@ids) {
            if ($c->is_uuid($id)) {
                $c->Do(" DELETE FROM stages WHERE id=? ", [ $id ]);
            }
        }
    }

    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors });
}



1;
