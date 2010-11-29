package Inprint::Advertising::Modules;

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
                t1.id,
                t2.id as edition, t2.shortcut as edition_shortcut,
                t3.id as fascicle, t3.shortcut as fascicle_shortcut,
                t4.id as place, t4.shortcut as place_shortcut,
                t1.place, t1.amount, t1.volume, t1.w, t1.h, 
                t1.title, t1.shortcut, t1.description, t1.created, t1.updated
            FROM ad_modules t1, editions t2, fascicles t3, ad_places t4
            WHERE t2.id = t1.edition AND t3.id = t1.fascicle AND t4.id = t1.place AND t1.id=?
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
        SELECT id, edition, fascicle, place, title, shortcut, description, amount, volume, w, h, created, updated
        FROM ad_modules WHERE 1=1
    ";
    
    if ($i_type eq "module") {
        $sql .= " AND place=? ";
    }
    push @data, $i_id;

    if ($i_type eq "module") {
        unless (@errors) {
            $result = $c->sql->Q(" $sql ", \@data)->Hashes;
            $c->render_json( { data => $result } );
        }
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
    
    my $i_place  = $c->param("place");
    my $i_amount = $c->param("amount");
    my $i_volume = $c->param("volume");
    my $i_w      = $c->param("w");
    my $i_h      = $c->param("h");
    
    my @errors;
    my $success = $c->json->false;
    
    push @errors, { id => "title", msg => "Incorrectly filled field"}
        unless ($c->is_text($i_title));
        
    push @errors, { id => "shortcut", msg => "Incorrectly filled field"}
        unless ($c->is_text($i_shortcut));
        
    push @errors, { id => "description", msg => "Incorrectly filled field"}
        unless ($c->is_text($i_description));
    
    #push @errors, { id => "access", msg => "Not enough permissions"}
    #    unless ($c->access->Check("domain.roles.manage"));
    
    push @errors, { id => "amount", msg => "Incorrectly filled field"}
        unless ($c->is_int($i_amount));
    
    push @errors, { id => "amount", msg => "Incorrectly filled field"}
        unless ($c->is_float($i_volume));
        
    push @errors, { id => "width", msg => "Incorrectly filled field"}
        unless ($c->is_int($i_w));
        
    push @errors, { id => "height", msg => "Incorrectly filled field"}
        unless ($c->is_int($i_h));
    
    push @errors, { id => "place", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_place));
        
    my $place;
    my $fascicle;
    my $edition;
    
    unless (@errors) {
        $place = $c->sql->Q(" SELECT * FROM ad_places WHERE id=? ", [ $i_place ])->Hash;
        push @errors, { id => "place", msg => "Incorrectly filled field"}
            unless ($place);
    }
    
    unless (@errors) {
        $fascicle = $c->sql->Q(" SELECT * FROM fascicles WHERE id=? ", [ $place->{fascicle} ])->Hash;
        push @errors, { id => "fascicle", msg => "Incorrectly filled field"}
            unless ($fascicle);
    }
    
    unless (@errors) {
        $edition  = $c->sql->Q(" SELECT * FROM editions WHERE id=? ", [ $place->{edition} ])->Hash;
        push @errors, { id => "edition", msg => "Incorrectly filled field"}
            unless ($edition);
    }
    
    unless (@errors) {
        $c->sql->Do("
            INSERT INTO ad_modules(id, edition, fascicle, place, title, shortcut, description, amount, volume, w, h, created, updated)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, now(), now());
        ", [
            $id, $edition->{id}, $fascicle->{id}, $place->{id},
            $i_title, $i_shortcut, $i_description,
            $i_amount, $i_volume, $i_w, $i_h
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
    
    my $i_amount = $c->param("amount");
    my $i_volume = $c->param("volume");
    my $i_w      = $c->param("w");
    my $i_h      = $c->param("h");

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
    
    #push @errors, { id => "access", msg => "Not enough permissions"}
    #    unless ($c->access->Check("domain.roles.manage"));
    
    push @errors, { id => "amount", msg => "Incorrectly filled field"}
        unless ($c->is_int($i_amount));
    
    push @errors, { id => "amount", msg => "Incorrectly filled field"}
        unless ($c->is_float($i_volume));
        
    push @errors, { id => "width", msg => "Incorrectly filled field"}
        unless ($c->is_int($i_w));
        
    push @errors, { id => "height", msg => "Incorrectly filled field"}
        unless ($c->is_int($i_h));
        
    unless (@errors) {
        $c->sql->Do("
            UPDATE ad_modules
                SET title=?, shortcut=?, description=?, amount=?, volume=?, w=?, h=?, updated=now()
            WHERE id =?;
        ", [ $i_title, $i_shortcut, $i_description, $i_amount, $i_volume, $i_w, $i_h, $i_id ]);
    }
    
    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors });
}

sub delete {
    my $c = shift;
    my @ids = $c->param("id");
    
    my @errors;
    my $success = $c->json->false;
    
    #push @errors, { id => "access", msg => "Not enough permissions"}
    #    unless ($c->access->Check("domain.roles.manage"));
    
    unless (@errors) {
        foreach my $id (@ids) {
            if ($c->is_uuid($id)) {
                $c->sql->Do(" DELETE FROM ad_modules WHERE id=? ", [ $id ]);
            }
        }
    }
    
    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors });
}

1;
