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
        SELECT
            t1.id, t1.serialnum, t1.title, t1.shortcut, t1.status, t1.payment, t1.readiness, t1.created, t1.updated, 
            edition.id as edition, edition.shortcut as edition_shortcut, 
            fascicle.id as fascicle, fascicle.shortcut as fascicle_shortcut,
            advertiser.id as advertiser, advertiser.shortcut as advertiser_shortcut,
            place.id as place, place.shortcut as place_shortcut,
            module.id as module, module.shortcut as module_shortcut,
            manager.id as manager, manager.shortcut as manager_shortcut,
            
            hole.x, hole.y, hole.h, hole.w,
            page.seqnum
        
        
        FROM ad_requests AS t1
        
            LEFT JOIN ad_places             AS place        ON place.id = t1.place
            LEFT JOIN ad_modules            AS module       ON module.id = t1.module
            LEFT JOIN profiles              AS manager      ON manager.id = t1.manager
            LEFT JOIN fascicles_map_holes   AS hole         ON hole.entity = t1.id
            LEFT JOIN ad_modules            AS linking      ON linking.id = hole.module
            LEFT JOIN fascicles_pages       AS page         ON page.id = hole.page
        
        , editions AS edition, fascicles AS fascicle, ad_advertisers AS advertiser
        
        WHERE edition.id = t1.edition AND fascicle.id = t1.fascicle AND fascicle.enabled=true AND advertiser.id = t1.advertiser
            AND t1.id = ?
        ", [ $i_id ])->Hash;
    }
    
    $success = $c->json->true unless (@errors);
    $c->render_json( { success => $success, errors => \@errors, data => $result } );
}

sub list {
    my $c = shift;
    
    my $i_id    = $c->param("id");
    my $i_type  = $c->param("type");
    
    my $result = [];
    
    my @errors;
    my $success = $c->json->false;

    push @errors, { id => "id", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_id));

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
            AND 1=1 
    ";
    
    if ($i_type eq "edition") {
        $sql .= " AND edition.id = ? ";
        push @data, $i_id;
    }
    
    if ($i_type eq "fascicle") {
        $sql .= " AND fascicle.id = ? AND fascicle.enabled=true";
        push @data, $i_id;
    }
    
    unless (@errors) {
        $result = $c->sql->Q(" $sql ", \@data)->Hashes;
        $c->render_json( { data => $result } );
    }
    
    $success = $c->json->true unless (@errors);
    $c->render_json( { success => $success, errors => \@errors, data => $result } );
}

sub create {
    my $c = shift;
    
    my $id = $c->uuid();
    
    my $i_title       = $c->param("title") || undef;
    my $i_shortcut    = $c->param("shortcut") || undef;
    my $i_description = $c->param("description") || undef;
    
    my $i_edition     = $c->param("edition") || undef;
    my $i_advertiser  = $c->param("advertiser") || undef;
    my $i_manager     = $c->param("manager") || undef;
    
    my $i_fascicle    = $c->param("fascicle") || undef;
    my $i_place       = $c->param("place") || undef;
    my $i_module      = $c->param("module") || undef;
    
    my $i_status       = $c->param("status") || undef;
    my $i_payment      = $c->param("payment") || undef;
    my $i_readiness    = $c->param("readiness") || undef;
    
    my @errors;
    my $success = $c->json->false;
    
    push @errors, { id => "edition", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_edition));
    
    push @errors, { id => "title", msg => "Incorrectly filled field"}
        unless ($c->is_text($i_title));
        
    push @errors, { id => "shortcut", msg => "Incorrectly filled field"}
        unless ($c->is_text($i_shortcut));
        
    push @errors, { id => "description", msg => "Incorrectly filled field"}
        unless ($c->is_text($i_description));
    
    #push @errors, { id => "access", msg => "Not enough permissions"}
    #    unless ($c->access->Check("domain.roles.manage"));
    
    unless (@errors) {
        $c->sql->Do("
            INSERT INTO ad_requests(
            id, title, shortcut, description,
            edition, advertiser, manager, fascicle, place, module,
            status, payment, readiness, created, updated)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, now(), now());
        ", [
            $id, $i_title, $i_shortcut, $i_description,
            
            $i_edition, $i_advertiser, $i_manager,
            $i_fascicle, $i_place, $i_module,
            $i_status, $i_payment, $i_readiness
        ]);
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

    my $i_advertiser  = $c->param("advertiser") || undef;
    my $i_manager     = $c->param("manager") || undef;
    
    my $i_fascicle    = $c->param("fascicle") || undef;
    my $i_place       = $c->param("place") || undef;
    my $i_module      = $c->param("module") || undef;
    
    my $i_status       = $c->param("status") || undef;
    my $i_payment      = $c->param("payment") || undef;
    my $i_readiness    = $c->param("readiness") || undef;

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
            UPDATE ad_requests SET
                title=?, shortcut=?, description=?, 
                advertiser=?, manager=?, 
                fascicle=?, place=?, module=?,
                status=?, payment=?, readiness=?, updated=now()
            WHERE id=?;

        ", [
            $i_title, $i_shortcut, $i_description,
            
            $i_advertiser, $i_manager,
            $i_fascicle, $i_place, $i_module,
            $i_status, $i_payment, $i_readiness,
            
            $i_id
        ]);
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
                $c->sql->Do(" DELETE FROM ad_requests WHERE id=? ", [ $id ]);
            }
        }
    }
    
    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors });
}

1;
