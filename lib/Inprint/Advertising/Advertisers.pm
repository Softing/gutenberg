package Inprint::Advertising::Advertisers;

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
    my $i_start    = $c->param("start") || 0;
    my $i_limit    = $c->param("limit") || 100;
    
    my @data;
    my $total;
    my $result = [];
    
    my @errors;
    my $success = $c->json->false;

    push @errors, { id => "edition", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_edition));
        
    push @errors, { id => "start", msg => "Incorrectly filled field"}
        unless ($c->is_int($i_start));
    
    push @errors, { id => "limit", msg => "Incorrectly filled field"}
        unless ($c->is_int($i_limit));
    
    unless (@errors) {
        
        $total = $c->sql->Q("
            SELECT count(*) FROM ad_advertisers t1, editions t2 WHERE t2.id = t1.edition AND t1.edition=?
        ", [ $i_edition ])->Value;
        
        $result = $c->sql->Q("
            SELECT t1.id, t2.id as edition, t2.shortcut as edition_shortcut, t1.serialnum, t1.title, t1.shortcut, t1.address, t1.contact, t1.phones, t1.inn, t1.kpp, t1.bank, t1.rs, t1.ks, t1.bik, t1.created, t1.updated
            FROM ad_advertisers t1, editions t2 WHERE t2.id = t1.edition AND t1.edition=?
            ORDER BY t1.shortcut LIMIT ? OFFSET ?
        ", [ $i_edition, $i_limit, $i_start ])->Hashes;
        
    }
    
    $success = $c->json->true unless (@errors);
    $c->render_json( { success => $success, errors => \@errors, data => $result, total => $total } );
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
