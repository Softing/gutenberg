package Inprint::Advertising::Requests;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
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
        $result = $c->sql->Q("
            SELECT id, title, shortcut, description
            FROM roles
            WHERE id =?
        ", [ $i_id ])->Hash;
    }
    
    $success = $c->json->true unless (@errors);
    $c->render_json( { success => $success, errors => \@errors, data => $result } );
}

sub list {
    my $c = shift;
    
    my $i_edition  = $c->param("edition");
    my $i_fascicle = $c->param("fascicle");
    
    
    my $result = [];
    
    my @errors;
    my $success = $c->json->false;

    push @errors, { id => "edition", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_edition));
    
    if ($i_fascicle) {
        push @errors, { id => "fascicle", msg => "Incorrectly filled field"}
            unless ($c->is_uuid($i_fascicle));
    }

    my @data;
    my $sql = "
        SELECT
            t1.id, t1.serialnum, t1.title, t1.shortcut, t1.status, t1.payment, t1.readiness, t1.created, t1.updated, 
            edition.id as edition, edition.shortcut as edition_shortcut, 
            fascicle.id as fascicle, fascicle.shortcut as fascicle_shortcut,
            advertiser.id as advertiser, advertiser.shortcut as advertiser_shortcut,
            place.id as place, place.shortcut as place_shortcut,
            manager.id as manager, manager.shortcut as manager_shortcut,
            hole.x, hole.y, hole.h, hole.w,
            page.seqnum
        
        
        FROM ad_requests AS t1
        
            LEFT JOIN ad_places             AS place        ON place.id = t1.place
            LEFT JOIN profiles              AS manager      ON manager.id = t1.manager
            LEFT JOIN fascicles_map_holes   AS hole         ON hole.entity = t1.id
            LEFT JOIN ad_modules            AS module       ON module.id = hole.module
            LEFT JOIN fascicles_pages       AS page         ON page.id = hole.page
        
        , editions AS edition, fascicles AS fascicle, ad_advertisers AS advertiser
        
        WHERE edition.id = t1.edition AND fascicle.id = t1.fascicle AND fascicle.enabled=true AND advertiser.id = t1.advertiser
            AND edition.id = ?
    ";
    push @data, $i_edition;
    
    unless (@errors) {
        
        if ($i_fascicle) {
            $sql .= " AND fascicle.id = ? ";
            push @data, $i_fascicle;
        }
        
        $result = $c->sql->Q(" $sql ", \@data)->Hashes;
        $c->render_json( { data => $result } );
    }
    
    $success = $c->json->true unless (@errors);
    $c->render_json( { success => $success, errors => \@errors, data => $result } );
}

sub create {
    my $c = shift;
    
    my $id = $c->uuid();
    
    my $i_title       = $c->param("title");
    my $i_shortcut    = $c->param("shortcut");
    my $i_description = $c->param("description");
    
    my @errors;
    my $success = $c->json->false;
    
    push @errors, { id => "title", msg => "Incorrectly filled field"}
        unless ($c->is_text($i_title));
        
    push @errors, { id => "shortcut", msg => "Incorrectly filled field"}
        unless ($c->is_text($i_shortcut));
        
    push @errors, { id => "description", msg => "Incorrectly filled field"}
        unless ($c->is_text($i_description));
    
    push @errors, { id => "access", msg => "Not enough permissions"}
        unless ($c->access->Check("domain.roles.manage"));
    
    unless (@errors) {
        $c->sql->Do("
            INSERT INTO roles(id, title, shortcut, description, created, updated)
            VALUES (?, ?, ?, ?, now(), now());
        ", [ $id, $i_title, $i_shortcut, $i_description ]);
    }
    
    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors });
}

sub update {
    my $c = shift;

    my $i_id          = $c->param("id");
    my $i_title       = $c->param("title");
    my $i_shortcut    = $c->param("shortcut");
    my $i_description = $c->param("description");

    my @errors;
    my $success = $c->json->false;

    push @errors, { id => "id", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_id));
        
    push @errors, { id => "title", msg => "Incorrectly filled field"}
        unless ($c->is_text($i_title));
        
    push @errors, { id => "shortcut", msg => "Incorrectly filled field"}
        unless ($c->is_text($i_shortcut));
        
    push @errors, { id => "description", msg => "Incorrectly filled field"}
        unless ($c->is_text($i_description));
    
    push @errors, { id => "access", msg => "Not enough permissions"}
        unless ($c->access->Check("domain.roles.manage"));
    
    unless (@errors) {
        $c->sql->Do("
            UPDATE roles
                SET title=?, shortcut=?, description=?, updated=now()
            WHERE id =?;
        ", [ $i_title, $i_shortcut, $i_description, $i_id ]);
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
        unless ($c->access->Check("domain.roles.manage"));
    
    unless (@errors) {
        foreach my $id (@ids) {
            if ($c->is_uuid($id)) {
                $c->sql->Do(" DELETE FROM roles WHERE id=? ", [ $id ]);
            }
        }
    }
    
    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors });
}

1;
