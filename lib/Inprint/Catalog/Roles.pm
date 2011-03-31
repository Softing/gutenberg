package Inprint::Catalog::Roles;

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
        $result = $c->Q("
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
    my $result = $c->Q("
        SELECT id, title, shortcut, description,
            array_to_string(
                ARRAY(
                    SELECT rules.title
                    FROM rules, map_role_to_rule mapping
                    WHERE mapping.rule = rules.id AND mapping.role = roles.id
                )
            , ', ') as rules
        FROM roles
        ORDER BY shortcut
    ")->Hashes;
    $c->render_json( { data => $result } );
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
        unless ($c->objectAccess("domain.roles.manage"));
    
    unless (@errors) {
        $c->Do("
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
        unless ($c->objectAccess("domain.roles.manage"));
    
    unless (@errors) {
        $c->Do("
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
        unless ($c->objectAccess("domain.roles.manage"));
    
    unless (@errors) {
        foreach my $id (@ids) {
            if ($c->is_uuid($id)) {
                $c->Do(" DELETE FROM roles WHERE id=? ", [ $id ]);
            }
        }
    }
    
    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors });
}


sub map {
    my $c = shift;

    my $i_id          = $c->param("id");
    my @i_rules       = $c->param("rules");
    my $i_recursive   = $c->param("recursive");
    
    my @errors;
    my $success = $c->json->false;
    
    push @errors, { id => "access", msg => "Not enough permissions"}
        unless ($c->objectAccess("domain.roles.manage"));
    
    unless (@errors) {
        $c->Do(" DELETE FROM map_role_to_rule WHERE role=? ", [ $i_id ]);
        foreach my $string (@i_rules) {
            my ($rule, $mode) = split "::", $string;
            if ($c->is_uuid($i_id) && $c->is_text($rule) && $c->is_text($mode)) {
                $c->Do(" INSERT INTO map_role_to_rule(role, rule, mode) VALUES (?, ?, ?); ", [$i_id, $rule, $mode]);
            }
        }
    }
    
    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors });
}

sub mapping {

    my $c = shift;

    my $i_id = $c->param("id");

    my @errors;
    my $success = $c->json->false;
    my $result = {};

    if ($c->is_uuid($i_id)) {
        my $data = $c->Q(" SELECT role, rule, mode FROM map_role_to_rule WHERE role =? ", [ $i_id ])->Hashes;
        foreach my $item (@$data) {
            $result->{ $item->{rule} } = $item->{mode};
        }
    }
    
    my @ids = $c->param("id");

    $c->render_json( { success => $success, errors => \@errors, data => $result } );
}

1;
