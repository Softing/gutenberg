package Inprint::Advertising::Pages;

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
            SELECT id, edition, title, shortcut, description, w, h, created, updated FROM ad_pages WHERE id=?
        ", [ $i_id ])->Hash;
    }
    
    $success = $c->json->true unless (@errors);
    $c->render_json( { success => $success, errors => \@errors, data => $result } );
}

sub list {
    my $c = shift;
    
    my $i_edition = $c->param("edition");
    
    my $result = [];
    
    my @errors;
    my $success = $c->json->false;

    push @errors, { id => "id", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_edition));
    
    my $edition = $c->sql->Q(" SELECT * FROM editions WHERE id = ? ", [ $i_edition ])->Hash;
    
    push @errors, { id => "edition", msg => "Incorrectly filled field"}
        unless ($edition->{id});
    
    my @params;
    my $sql = " SELECT id, edition, title, shortcut, description, w, h, created, updated FROM ad_pages WHERE edition=? ";
    
    unless (@errors) {

        push @params, $edition->{id};
        
        $result = $c->sql->Q(" $sql ", \@params)->Hashes;
        
    }
    
    $success = $c->json->true unless (@errors);
    $c->render_json( { success => $success, errors => \@errors, data => $result } );
}

sub create {
    my $c = shift;
    
    my $id = $c->uuid();
    
    my $i_edition     = $c->param("edition");
    
    my $i_title       = $c->param("title");
    my $i_shortcut    = $c->param("shortcut");
    my $i_description = $c->param("description");
    
    my @i_w      = $c->param("w");
    my @i_h      = $c->param("h");
    
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
    
    #push @errors, { id => "width", msg => "Incorrectly filled field"}
    #    unless ($c->is_int($i_w));
    #    
    #push @errors, { id => "height", msg => "Incorrectly filled field"}
    #    unless ($c->is_int($i_h));
        
    
    #my $fascicle;
    my $edition;
    
    #unless (@errors) {
    #    $fascicle = $c->sql->Q(" SELECT * FROM fascicles WHERE id=? ", [ $place->{fascicle} ])->Hash;
    #    push @errors, { id => "fascicle", msg => "Incorrectly filled field"}
    #        unless ($fascicle);
    #}
    
    unless (@errors) {
        $edition  = $c->sql->Q(" SELECT * FROM editions WHERE id=? ", [ $i_edition ])->Hash;
        push @errors, { id => "edition", msg => "Incorrectly filled field"}
            unless ($edition);
    }
    
    unless (@errors) {
        $c->sql->Do("
            INSERT INTO ad_pages(id, edition, title, shortcut, description, w, h, created, updated)
            VALUES (?, ?, ?, ?, ?, ?, ?, now(), now());
        ", [ $id, $edition->{id}, $i_title, $i_shortcut, $i_description, \@i_w, \@i_h ]);
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
    
    my @i_w      = $c->param("w");
    my @i_h      = $c->param("h");

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
    
    unless (@errors) {
        $c->sql->Do("
            UPDATE ad_pages SET title=?, shortcut=?, description=?, w=?, h=?, updated=now() WHERE id = ? ;
        ", [ $i_title, $i_shortcut, $i_description, \@i_w, \@i_h, $i_id ]);
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
                $c->sql->Do(" DELETE FROM ad_pages WHERE id=? ", [ $id ]);
            }
        }
    }
    
    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors });
}

1;
