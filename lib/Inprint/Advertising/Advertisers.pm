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
            SELECT t1.id, t2.id as edition, t2.shortcut as edition_shortcut, t1.serialnum, t1.title, t1.shortcut, t1.description, t1.address, t1.contact, t1.phones, t1.inn, t1.kpp, t1.bank, t1.rs, t1.ks, t1.bik, t1.created, t1.updated
            FROM ad_advertisers t1, editions t2 WHERE t2.id = t1.edition AND t1.id=?
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
            SELECT t1.id, t2.id as edition, t2.shortcut as edition_shortcut, t1.serialnum, t1.title, t1.shortcut, t1.description, t1.address, t1.contact, t1.phones, t1.inn, t1.kpp, t1.bank, t1.rs, t1.ks, t1.bik, t1.created, t1.updated
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
    
    my $i_edition     = $c->param("edition");
    my $i_title       = $c->param("title");
    my $i_shortcut    = $c->param("shortcut");
    my $i_description = $c->param("description");
    
    my $i_contact     = $c->param("contact");
    my $i_address     = $c->param("address");
    my $i_phones      = $c->param("phones");
    my $i_rs          = $c->param("rs");
    my $i_bank        = $c->param("bank");
    my $i_bik         = $c->param("bik");
    my $i_inn         = $c->param("inn");
    my $i_kpp         = $c->param("kpp");
    my $i_ks          = $c->param("ks");
    
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
    
    my $edition;
    unless (@errors) {
        $edition  = $c->sql->Q(" SELECT * FROM editions WHERE id=? ", [ $i_edition ])->Hash;
        push @errors, { id => "edition", msg => "Incorrectly filled field"}
            unless ($edition);
    }
    
    unless (@errors) {
        $c->sql->Do("
            INSERT INTO ad_advertisers(
                id, edition, title, shortcut, description,
                address, contact, phones,
                inn, kpp, bank, rs, ks, bik,
                created, updated)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, now(), now());
        ", [
            $id, $edition->{id}, $i_title, $i_shortcut, $i_description,
            $i_address, $i_contact, $i_phones,
            $i_inn, $i_kpp, $i_bank, $i_rs, $i_ks, $i_bik
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
    
    my $i_contact     = $c->param("contact");
    my $i_address     = $c->param("address");
    my $i_phones      = $c->param("phones");
    my $i_rs          = $c->param("rs");
    my $i_bank        = $c->param("bank");
    my $i_bik         = $c->param("bik");
    my $i_inn         = $c->param("inn");
    my $i_kpp         = $c->param("kpp");
    my $i_ks          = $c->param("ks");

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
    
    unless (@errors) {
        $c->sql->Do("
            UPDATE ad_advertisers SET
                title=?, shortcut=?, description=?, 
                address=?, contact=?, phones=?,
                inn=?, kpp=?, bank=?, rs=?, ks=?, bik=?,
                updated=now()
            WHERE id =?;
        ", [
                $i_title, $i_shortcut, $i_description,
                $i_address, $i_contact, $i_phones,
                $i_inn, $i_kpp, $i_bank, $i_rs, $i_ks, $i_bik,
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
    
    #push @errors, { id => "access", msg => "Not enough permissions"}
    #    unless ($c->access->Check("domain.roles.manage"));
    
    unless (@errors) {
        foreach my $id (@ids) {
            if ($c->is_uuid($id)) {
                $c->sql->Do(" DELETE FROM ad_advertisers WHERE id=? ", [ $id ]);
            }
        }
    }
    
    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors });
}


1;
