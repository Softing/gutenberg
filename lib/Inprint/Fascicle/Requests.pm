package Inprint::Fascicle::Requests;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use utf8;
use strict;
use warnings;

use base 'Inprint::BaseController';

sub process {
    
    my $c = shift;
    
    if ($c->param("id")) {
        $c->update();
    }
    
    else {
        $c->create();
    }
    
    return $c;
}

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
            
                LEFT JOIN fascicles_tmpl_places     AS place            ON place.id = t1.place
                LEFT JOIN fascicles_tmpl_modules    AS module           ON module.id = t1.module
                LEFT JOIN profiles                  AS manager          ON manager.id = t1.manager
                
                LEFT JOIN fascicles_modules         AS rl_module        ON hole.entity = t1.id
                LEFT JOIN fascicles_map_modules     AS rl_module_map    ON hole.entity = t1.id
                
                LEFT JOIN fascicles_pages           AS page             ON page.id = hole.page
            
            , editions AS edition, fascicles AS fascicle, ad_advertisers AS advertiser
            
            WHERE edition.id = t1.edition AND fascicle.id = t1.fascicle AND fascicle.is_enabled=true AND advertiser.id = t1.advertiser
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
        
        WHERE edition.id = t1.edition AND fascicle.id = t1.fascicle AND fascicle.is_enabled=true AND advertiser.id = t1.advertiser
            AND 1=1 
    ";
    
    if ($i_type eq "edition") {
        $sql .= " AND edition.id = ? ";
        push @data, $i_id;
    }
    
    if ($i_type eq "fascicle") {
        $sql .= " AND fascicle.id = ? AND fascicle.is_enabled=true";
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
    
    my $i_shortcut    = $c->param("shortcut") || undef;
    my $i_description = $c->param("description") || undef;
    
    my $i_fascicle    = $c->param("fascicle") || undef;
    my $i_advertiser  = $c->param("advertiser") || undef;
    
    my $i_module      = $c->param("module") || undef;
    my $i_template    = $c->param("template") || undef;
    
    my $i_status      = $c->param("status") || undef;
    my $i_payment     = $c->param("payment") || undef;
    my $i_readiness   = $c->param("readiness") || undef;
    
    my @errors;
    my $success = $c->json->false;
    
    push @errors, { id => "shortcut", msg => "Incorrectly filled field"}
        unless ($c->is_text($i_shortcut));
        
    push @errors, { id => "description", msg => "Incorrectly filled field"}
        unless ($c->is_text($i_description));
    
    unless ($i_module) {
        unless ($i_template) {
            push @errors, { id => "module-or-template", msg => "Incorrectly filled field"}
        }
    }
    
    if (length $i_module > 0) {
        push @errors, { id => "module", msg => "Incorrectly filled field"}
            unless ($c->is_uuid($i_module));
    }
    
    if (length $i_template > 0) {
        push @errors, { id => "template", msg => "Incorrectly filled field"}
            unless ($c->is_uuid($i_template));
    }
    
    my $fascicle; unless(@errors) {
        $fascicle = $c->sql->Q(" SELECT * FROM fascicles WHERE id=? ", [ $i_fascicle ])->Hash;
        push @errors, { id => "fascicle", msg => "Can't find object"}
            unless ($fascicle->{id});
    }
    
    my $advertiser; unless(@errors) {
        $advertiser = $c->sql->Q(" SELECT * FROM ad_advertisers WHERE id=? ", [ $i_advertiser ])->Hash;
        push @errors, { id => "advertiser", msg => "Can't find object"}
            unless ($advertiser->{id});
    }
    
    #push @errors, { id => "access", msg => "Not enough permissions"}
    #    unless ($c->access->Check("domain.roles.manage"));
    
    if ($i_module) {
        
        my $module; 
        unless(@errors) {
            $module = $c->sql->Q(" SELECT * FROM fascicles_modules WHERE id=? ", [ $i_module ])->Hash;
            push @errors, { id => "module", msg => "Can't find object"}
                unless ($module->{id});
        }
        
        my $place;
        unless(@errors) {
            $place = $c->sql->Q("
                    SELECT t1.* FROM fascicles_tmpl_places t1
                    WHERE t1.id=?
                ", [ $module->{place} ])->Hash;
            push @errors, { id => "place", msg => "Can't find object"}
                unless ($place->{id});
        }
        
        my $template;
        unless(@errors) {
            $template = $c->sql->Q("
                    SELECT t1.* FROM fascicles_tmpl_modules t1
                    WHERE t1.id=?
                ", [ $module->{origin} ])->Hash;
            push @errors, { id => "template", msg => "Can't find object"}
                unless ($template->{id});
        }
        
        my $pages;
        unless(@errors) {
            $pages = $c->sql->Q("
                    SELECT t2.seqnum
                    FROM fascicles_map_modules t1, fascicles_pages t2 
                    WHERE t2.id = t1.page AND t1.fascicle=? AND t1.module=?
                    ORDER BY t2.seqnum
                ", [ $module->{fascicle}, $module->{id} ])->Values;
        }
        
        unless (@errors) {
            $c->sql->Do("
                INSERT INTO fascicles_requests(
                    id,
                    edition, fascicle,
                    advertiser, advertiser_shortcut, 
                    place, place_shortcut,
                    manager, manager_shortcut,
                    origin, origin_shortcut, origin_area, origin_x, origin_y, origin_w, origin_h, 
                    module, amount,
                    pages, firstpage,
                    shortcut, description,
                    status, payment, readiness,
                    created, updated)
                VALUES (
                    ?,
                    ?, ?,
                    ?, ?,
                    ?, ?,
                    ?, ?,
                    ?, ?, ?, ?, ?, ?, ?,
                    ?, ?,
                    ?, ?,
                    ?, ?,
                    ?, ?, ?,
                    now(), now());
            ", [
                $id,
                $fascicle->{edition}, $fascicle->{id},
                $advertiser->{id}, $advertiser->{shortcut},
                $place->{id}, $place->{shortcut},
                $c->QuerySessionGet("member.id"), $c->QuerySessionGet("member.shortcut"),
                $template->{id}, $template->{shortcut}, $template->{area},  $template->{x},  $template->{y},  $template->{w},  $template->{h},
                $module->{id}, $module->{amount},
                join (', ', @$pages), @$pages[0],
                $i_shortcut, $i_description,
                $i_status, $i_payment, $i_readiness
            ]);
        }
        
    }
    
    if ($i_template) {
        
        my $template;
        unless(@errors) {
            $template = $c->sql->Q(" SELECT * FROM fascicles_tmpl_modules WHERE id=? ", [ $i_template ])->Hash;
            push @errors, { id => "template", msg => "Can't find object"}
                unless ($template->{id});
        }
        
        my $place;
        unless(@errors) {
            $place = $c->sql->Q("
                    SELECT t1.* FROM fascicles_tmpl_places t1, fascicles_tmpl_index t2
                    WHERE t2.place=t1.id AND t2.nature='module' AND t2.entity=?
                ", [ $template->{id} ])->Hash;
            push @errors, { id => "place", msg => "Can't find object"}
                unless ($place->{id});
        }
        
        unless (@errors) {
            $c->sql->Do("
                INSERT INTO fascicles_requests(
                    id,
                    edition, fascicle,
                    advertiser, advertiser_shortcut, 
                    place, place_shortcut,
                    manager, manager_shortcut,
                    origin, origin_shortcut, origin_area, origin_x, origin_y, origin_w, origin_h, 
                    module, amount,
                    shortcut, description,
                    status, payment, readiness,
                    created, updated)
                VALUES (
                    ?,
                    ?, ?,
                    ?, ?,
                    ?, ?,
                    ?, ?,
                    ?, ?, ?, ?, ?, ?, ?,
                    null, ?,
                    ?, ?,
                    ?, ?, ?,
                    now(), now());
            ", [
                $id,
                $fascicle->{edition}, $fascicle->{id},
                $advertiser->{id}, $advertiser->{shortcut},
                $place->{id}, $place->{shortcut},
                $c->QuerySessionGet("member.id"), $c->QuerySessionGet("member.shortcut"),
                $template->{id}, $template->{shortcut}, $template->{area},  $template->{x},  $template->{y},  $template->{w},  $template->{h},
                $template->{amount},
                $i_shortcut, $i_description,
                $i_status, $i_payment, $i_readiness
            ]);
        }
        
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

sub move {
    my $c = shift;
    
    my $i_fascicle  = $c->param("fascicle");
    my @i_requests    = $c->param("request");
    my @i_pages       = $c->param("page");
    
    my @errors;
    my $success = $c->json->false;
    
    push @errors, { id => "access", msg => "Not enough permissions"}
        unless ($c->access->Check("domain.roles.manage"));
    
    my @pages;
    
    foreach my $string (@i_pages) {
        
        my ($page_id, $seqnum) = split "::", $string;
        my $page = $c->sql->Q(" SELECT * FROM fascicles_pages WHERE id=? AND seqnum=? ", [ $page_id, $seqnum ])->Hash;
        
        if ($page->{id}) {
            push @pages, $page;
        }
        
        push @errors, { id => "page", msg => "Can't find object"}
            unless ($page->{id});
    }
    
    unless (@errors) {
        
        foreach my $id (@i_requests) {
            
            my $request;
            
            if ($c->is_uuid($id)) {
                $request = $c->sql->Q(" SELECT * FROM fascicles_requests WHERE id=? ", [ $id ])->Hash;
            }
            
            my $module;
            
            if ($request->{id}) {
                $module = $c->sql->Q(" SELECT * FROM fascicles_modules WHERE id=? ", [ $request->{module} ])->Hash;
            }
            
            if ($module->{id}) {
                
                $c->sql->bt;
                
                $c->sql->Do(" DELETE FROM fascicles_map_modules WHERE module=? ", [ $request->{module} ]);
                
                foreach my $page ( @pages ) {
                    
                    $c->sql->Do("
                        INSERT INTO fascicles_map_modules(
                            edition, fascicle, module, page, placed, x, y, created, updated)
                        VALUES (?, ?, ?, ?, false, ?, ?, now(), now());
                        ", [
                        $request->{edition}, $request->{fascicle}, $module->{id}, $page->{id}, "1/1", "1/1"
                    ]);
                    
                }
                
                $c->sql->et;
            }
        }
    }
    
    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors });
}

sub delete {
    my $c = shift;
    
    my $i_fascicle  = $c->param("fascicle");
    
    my $d_request = $c->param("delete-request");
    my $d_module  = $c->param("delete-module");
    
    my @requests  = $c->param("request");
    
    my @errors;
    my $success = $c->json->false;
    
    push @errors, { id => "access", msg => "Not enough permissions"}
        unless ($c->access->Check("domain.roles.manage"));
    
    unless (@errors) {
        
        foreach my $id (@requests ) {
            
            my $request;
            
            if ($c->is_uuid($id)) {
                $request = $c->sql->Q(" SELECT * FROM fascicles_requests WHERE id=? ", [ $id ])->Hash;
            }
            
            if ($request->{id}) {
                
                $c->sql->bt;
                
                if ($d_request eq "true") {
                    
                    $c->sql->Do(" DELETE FROM fascicles_requests WHERE id=? ", [ $request->{id} ]);
                    
                    my $exist = $c->sql->Q(" SELECT EXISTS ( SELECT id FROM fascicles_requests WHERE module=? ) ", [ $request->{module} ])->Value;
                    
                    if ($d_module eq "true") {
                        unless ($exist) {
                            $c->sql->Do(" DELETE FROM fascicles_modules WHERE id=? ", [ $request->{module} ]);
                        }
                    }
                    
                }
                
                $c->sql->et;
            }
        }
    }
    
    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors });
}

1;
