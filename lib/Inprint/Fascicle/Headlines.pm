package Inprint::Fascicle::Headlines;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

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
        $result = $c->sql->Q(" SELECT * FROM index_fascicles WHERE id = ? ", [ $i_id ])->Hash;
    }
    
    $success = $c->json->true unless (@errors);
    $c->render_json( { success => $success, errors => \@errors, data => $result } );
}

sub tree {

    my $c = shift;

    my $i_fasclce = $c->param("fascicle");
    
    my @result;
    my @errors;
    my $success = $c->json->false;
    
    push @errors, { id => "id", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_fasclce));
    
    my $fascicle;
    unless (@errors) {
        $fascicle = $c->sql->Q(" SELECT * FROM fascicles WHERE id=? ", [ $i_fasclce ])->Hash;
        push @errors, { id => "fascicle", msg => "Incorrectly filled field"}
            unless ($fascicle->{id});
    }
    
    unless (@errors) {
        
        my $sql;
        my @data;
        
        $sql = "
            SELECT t1.id, t1.shortcut, 'marker' as icon, 'current' as status
            FROM index_fascicles t1 WHERE t1.fascicle = ? AND nature = 'headline'
            ORDER BY t1.shortcut ASC
        ";
        push @data, $fascicle->{id};
        
        my $data = $c->sql->Q($sql, \@data)->Hashes;
        
        foreach my $item (@$data) {
            my $record = {
                id      => $item->{id},
                icon    => $item->{icon},
                status  => $item->{status},
                text    => $item->{shortcut},
                leaf    => $c->json->true
            };
            push @result, $record;
        }
        
    }
    
    $success = $c->json->true unless (@errors);
    $c->render_json( \@result );
}

sub create {
    my $c = shift;

    my $id            = $c->uuid();

    my $i_fascicle    = $c->param("fascicle");
    my $i_title       = $c->param("title");
    my $i_shortcut    = $c->param("shortcut");
    my $i_description = $c->param("description");

    my @errors;
    my $success = $c->json->false;
    
    push @errors, { id => "fascicle", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_fascicle));
    
    push @errors, { id => "title", msg => "Incorrectly filled field"}
        unless ($c->is_text($i_title));
        
    push @errors, { id => "shortcut", msg => "Incorrectly filled field"}
        unless ($c->is_text($i_shortcut));
        
    push @errors, { id => "description", msg => "Incorrectly filled field"}
        unless ($c->is_text($i_description));
        
    push @errors, { id => "access", msg => "Not enough permissions"}
        unless ($c->access->Check("domain.departments.manage"));
    
    my $fascicle = $c->sql->Q(" SELECT * FROM fascicles WHERE id=? ", [ $i_fascicle ])->Hash;
    push @errors, { id => "fascicle", msg => "Incorrectly filled field"}
        unless ($fascicle->{id});
    
    unless (@errors) {
        my $exists_title = $c->sql->Q("
                SELECT count(*)
                FROM index_fascicles
                WHERE fascicle=? AND nature=? AND lower(title) = lower(?)
            ", [ $fascicle->{id}, "headline", $i_title ])->Value;
        push @errors, { id => "title", msg => "Already exists"}
            if ($exists_title);
        
        my $exists_shortcut = $c->sql->Q("
                SELECT count(*)
                FROM index_fascicles
                WHERE fascicle=? AND nature=? AND lower(shortcut) = lower(?)
            ", [ $fascicle->{id}, "headline", $i_shortcut ])->Value;
        push @errors, { id => "shortcut", msg => "Already exists"}
            if ($exists_shortcut);
    }
    
    unless (@errors) {
        $c->sql->Do("
            INSERT INTO index_fascicles(id, edition, fascicle, origin, nature, parent, title, shortcut, description, created, updated)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, now(), now());
        ", [ $id, $fascicle->{edition}, $fascicle->{id}, $id, "headline", $id, $i_title, $i_shortcut, $i_description ]);
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
        
    #push @errors, { id => "access", msg => "Not enough permissions"}
    #    unless ($c->access->Check("domain.editions.manage"));
    
    my $headline = $c->sql->Q(" SELECT * FROM index_fascicles WHERE id=? ", [ $i_id ])->Hash;
    push @errors, { id => "headline", msg => "Incorrectly filled field"}
        unless ($headline->{id});
    
    unless (@errors) {
        
        my $exists_title = $c->sql->Q("
                SELECT count(*)
                FROM index_fascicles
                WHERE id <> ? AND fascicle=? AND nature=? AND lower(title) = lower(?)
            ", [ $headline->{id}, $headline->{fascicle}, "headline", $i_title ])->Value;
        push @errors, { id => "title", msg => "Already exists"}
            if ($exists_title);
        
        my $exists_shortcut = $c->sql->Q("
                SELECT count(*)
                FROM index_fascicles
                WHERE id <> ? AND fascicle=? AND nature=? AND lower(shortcut) = lower(?)
            ", [ $headline->{id}, $headline->{fascicle}, "headline", $i_shortcut ])->Value;
        push @errors, { id => "shortcut", msg => "Already exists"}
            if ($exists_shortcut);
    }
    
    unless (@errors) {
        $c->sql->Do(" UPDATE index_fascicles SET title=?, shortcut=?, description=? WHERE id=? ",
            [ $i_title, $i_shortcut, $i_description, $i_id ]);
    }

    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors });
}

sub delete {
    my $c = shift;
    my $i_id = $c->param("id");

    my @errors;
    my $success = $c->json->false;

    push @errors, { id => "id", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_id));
    
    #push @errors, { id => "access", msg => "Not enough permissions"}
    #    unless ($c->access->Check("domain.editions.manage"));
    
    unless (@errors) {
        $c->sql->Do(" DELETE FROM index_fascicles WHERE id =? AND ( origin <> '00000000-0000-0000-0000-000000000000' ) ", [ $i_id ]);
        $c->sql->Do(" DELETE FROM index_fascicles WHERE parent=? ", [ $i_id ]);
    }
    
    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors });
    
}

1;
