package Inprint::Catalog::Readiness;

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
        $result = $c->sql->Q("
            SELECT id, color, weight as percent, title, shortcut, description, created, updated
            FROM readiness
            WHERE id=?
        ", [ $i_id ])->Hash;
    }
    
    $success = $c->json->true unless (@errors);
    
    $c->render_json( { success => $success, errors => \@errors, data => $result } );
}

sub list {
    my $c = shift;
    my $result = $c->sql->Q("
        SELECT id, color, weight as percent, title, shortcut, description, created, updated
        FROM readiness ORDER BY weight, shortcut;
    ")->Hashes;
    $c->render_json( { data => $result } );
}

sub create {
    my $c = shift;

    my $id            = $c->uuid();

    my $i_title       = $c->param("title");
    my $i_shortcut    = $c->param("shortcut");
    my $i_description = $c->param("description");
    my $i_color       = $c->param("color");
    my $i_percent     = $c->param("percent");

    my @errors;
    my $success = $c->json->false;
    
    push @errors, { id => "title", msg => "Incorrectly filled field"}
        unless ($c->is_text($i_title));
        
    push @errors, { id => "shortcut", msg => "Incorrectly filled field"}
        unless ($c->is_text($i_shortcut));
        
    push @errors, { id => "description", msg => "Incorrectly filled field"}
        unless ($c->is_text($i_description));

    push @errors, { id => "color", msg => "Incorrectly filled field"}
        unless ($c->is_text($i_color));
        
    push @errors, { id => "percent", msg => "Incorrectly filled field"}
        unless ($c->is_int($i_percent));
    
    push @errors, { id => "access", msg => "Not enough permissions"}
        unless ($c->access->Check("domain.readiness.manage"));
    
    unless (@errors) {
        $c->sql->Do("
            INSERT INTO readiness (
                id, color, weight, title, shortcut, description, created, updated)
            VALUES (?, ?, ?, ?, ?, ?, now(), now());
        ", [ $id, $i_color, $i_percent, $i_title, $i_shortcut, $i_description ]);
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
    my $i_color       = $c->param("color");
    my $i_percent     = $c->param("percent");

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

    push @errors, { id => "color", msg => "Incorrectly filled field"}
        unless ($c->is_text($i_color));
        
    push @errors, { id => "percent", msg => "Incorrectly filled field"}
        unless ($c->is_int($i_percent));
    
    push @errors, { id => "access", msg => "Not enough permissions"}
        unless ($c->access->Check("domain.readiness.manage"));
    
    unless (@errors) {
        $c->sql->Do("
            UPDATE readiness SET color=?, weight=?, title=?, shortcut=?, description=?
            WHERE id=? ",
        [ $i_color, $i_percent, $i_title, $i_shortcut, $i_description, $i_id ]);
    }
    
    $success = $c->json->true unless (@errors);
    
    $c->render_json({ success => $success, errors => \@errors });
}

sub delete {
    my $c = shift;
    my @i_ids = $c->param("id");

    my @errors;
    my $success = $c->json->false;

    push @errors, { id => "access", msg => "Not enough permissions"}
        unless ($c->access->Check("domain.readiness.manage"));

    unless (@errors) {
        foreach my $id (@i_ids) {
            if ($c->is_uuid($id)) {
                $c->sql->Do(" DELETE FROM readiness WHERE id =? ", [ $id ]);
            }
        }
    }

    $success = $c->json->true unless (@errors);
    
    $c->render_json({ success => $success, errors => \@errors });
}

1;
