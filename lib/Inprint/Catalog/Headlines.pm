package Inprint::Catalog::Headlines;

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
        $result = $c->sql->Q(" SELECT * FROM index WHERE id = ? ", [ $i_id ])->Hash;
    }
    
    $success = $c->json->true unless (@errors);
    $c->render_json( { success => $success, errors => \@errors, data => $result } );
}

sub tree {

    my $c = shift;

    my $i_edition = $c->param("node");
    
    my @errors;
    my $success = $c->json->false;
    
    push @errors, { id => "id", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_edition));
    
    my $edition = $c->sql->Q(" SELECT * FROM editions WHERE id=? ", [ $i_edition ])->Hash;
    push @errors, { id => "edition", msg => "Incorrectly filled field"}
        unless ($edition->{id});
    
    my @result;
    unless (@errors) {
        
        my $sql;
        my @data;
        
        my $editions = $c->sql->Q("
                SELECT id FROM editions WHERE path @> ? order by path asc; 
            ", [ $edition->{path} ])->Values;
        
        $sql = "
            (
                SELECT t1.id, t1.shortcut, 'marker' as icon, 'current' as status
                FROM index t1 WHERE t1.edition = ? AND nature = 'headline'
                ORDER BY t1.shortcut ASC
            ) UNION ALL (
                SELECT t1.id, t1.shortcut, 'marker--arrow' as icon, 'child' as status
                FROM index t1 WHERE t1.edition = ANY(?) AND t1.edition <> ? AND nature = 'headline'
                ORDER BY t1.shortcut ASC
            )
        ";
        push @data, $edition->{id};
        push @data, $editions;
        push @data, $edition->{id};
        
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

    my $i_edition     = $c->param("edition");
    my $i_title       = $c->param("title");
    my $i_shortcut    = $c->param("shortcut");
    my $i_description = $c->param("description");

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
        
    push @errors, { id => "access", msg => "Not enough permissions"}
        unless ($c->access->Check("domain.departments.manage"));
    
    my $edition = $c->sql->Q(" SELECT * FROM editions WHERE id=? ", [ $i_edition ])->Hash;
    push @errors, { id => "edition", msg => "Incorrectly filled field"}
        unless ($edition->{id});
    
    unless (@errors) {
        
        my $editions = $c->sql->Q("
                SELECT id FROM editions WHERE path @> ? OR path <@ ? order by path asc; 
            ", [ $edition->{path}, $edition->{path} ])->Values;
        
        my $exists_title = $c->sql->Q("
                SELECT count(*) FROM index WHERE edition=ANY(?) AND nature=?
                AND lower(title) = lower(?)
            ", [ $editions, "headline", $i_title ])->Value;
        
        push @errors, { id => "title", msg => "Already exists"}
            if ($exists_title);
            
        my $exists_shortcut = $c->sql->Q("
                SELECT count(*) FROM index WHERE edition=ANY(?) AND nature=?
                AND lower(shortcut) = lower(?)
            ", [ $editions, "headline", $i_shortcut ])->Value;
        
        push @errors, { id => "shortcut", msg => "Already exists"}
            if ($exists_shortcut);
    }
    
    unless (@errors) {
        $c->sql->Do("
            INSERT INTO index (id, edition, nature, parent, title, shortcut, description, created, updated)
            VALUES (?, ?, ?, ?, ?, ?, ?, now(), now());
        ", [ $id, $edition->{id}, "headline", $edition->{id}, $i_title, $i_shortcut, $i_description ]);
    }
    
    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors });
}

sub update {
    my $c = shift;
    
    my $i_id          = $c->param("id");
    my $i_path        = $c->param("path");
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
        unless ($c->access->Check("domain.editions.manage"));
    
    my $headline;
    my $edition;
    
    $headline = $c->sql->Q(" SELECT * FROM index WHERE id=? ", [ $i_id ])->Hash;
    push @errors, { id => "id", msg => "Incorrectly filled field"}
        unless ($headline->{id});
    
    unless (@errors) {
        $edition = $c->sql->Q(" SELECT * FROM editions WHERE id=? ", [ $headline->{edition} ])->Hash;
        push @errors, { id => "edition", msg => "Incorrectly filled field"}
            unless ($edition->{id});
    }
    
    unless (@errors) {
        
        my $editions = $c->sql->Q("
                SELECT id FROM editions WHERE path @> ? OR path <@ ? order by path asc; 
            ", [ $edition->{path}, $edition->{path} ])->Values;
        
        my $exists_title = $c->sql->Q("
                SELECT count(*) FROM index WHERE edition=ANY(?) AND nature=?
                AND lower(title) = lower(?)
            ", [ $editions, "headline", $i_title ])->Value;
        
        push @errors, { id => "title", msg => "Already exists"}
            if ($exists_title);
            
        my $exists_shortcut = $c->sql->Q("
                SELECT count(*) FROM index WHERE edition=ANY(?) AND nature=?
                AND lower(shortcut) = lower(?)
            ", [ $editions, "headline", $i_shortcut ])->Value;
        
        push @errors, { id => "shortcut", msg => "Already exists"}
            if ($exists_shortcut);
    }
    
    unless (@errors) {
        die 1;
        $c->sql->Do(" UPDATE index SET title=?, shortcut=?, description=? WHERE id=? ",
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
    
    push @errors, { id => "access", msg => "Not enough permissions"}
        unless ($c->access->Check("domain.editions.manage"));
    
    unless (@errors) {
        $c->sql->Do("
            DELETE FROM index WHERE id =?
            AND ( edition <> '00000000-0000-0000-0000-000000000000' AND parent <> '00000000-0000-0000-0000-000000000000' )
        ", [ $i_id ]);
    }
    
    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors });
    
}

1;
