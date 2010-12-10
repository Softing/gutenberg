package Inprint::Fascicle::Indexes;

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
        $result = $c->sql->Q("
            SELECT t1.*,
                subpath(path, -2,1) as parent,
                (select shortcut from catalog where subpath(path, -1,1) = subpath(t1.path, -2,1) ) as parent_shortcut
            FROM catalog t1 WHERE t1.id = ?
        ", [ $i_id ])->Hash;
    }
    
    $success = $c->json->true unless (@errors);
    $c->render_json( { success => $success, errors => \@errors, data => $result } );
}

sub headlines {

    my $c = shift;

    my $i_node = $c->param("node");
    
    my @errors;
    my $success = $c->json->false;
    
    push @errors, { id => "id", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_node));
    
    my @result;
    unless (@errors) {
        my $sql;
        my @data;
        
        $sql = "
            SELECT DISTINCT t1.id, t1.shortcut as title FROM index_fascicles
            WHERE t1.fascicle=? AND t1.nature = 'headline'
            ORDER BY t1.shortcut
        ";
        push @data, $i_node;
        
        my $data = $c->sql->Q($sql, \@data)->Hashes;
        
        foreach my $item (@$data) {
            my $record = {
                id   => $item->{id},
                icon => "marker",
                text => $item->{shortcut},
                leaf => $c->json->true,
                data => $item
            };
            push @result, $record;
        }
        
        
    }

    $success = $c->json->true unless (@errors);
    $c->render_json( \@result );
}

sub rubrics {
    my $c = shift;
    
    my $i_node = $c->param("node");
    
    my @errors;
    my $success = $c->json->false;
    
    push @errors, { id => "id", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_node));
    
    my $result;
    unless (@errors) {
        $result = $c->sql->Q("
            SELECT DISTINCT t1.id, t1.shortcut as title FROM index_fascicles
            WHERE t1.fascicle=? AND t1.nature = 'rubric'
            ORDER BY t1.shortcut
        ", [ $i_node ] )->Hashes;
    }
    
    $success = $c->json->true unless (@errors);
    $c->render_json( { success => $success, errors => \@errors, data => $result || [] } );
}

sub create {
    my $c = shift;

    my $id            = $c->uuid();

    my $i_path        = $c->param("path");
    my $i_title       = $c->param("title");
    my $i_shortcut    = $c->param("shortcut");
    my $i_description = $c->param("description");

    my @errors;
    my $success = $c->json->false;
    
    push @errors, { id => "path", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_path));
    
    push @errors, { id => "title", msg => "Incorrectly filled field"}
        unless ($c->is_text($i_title));
        
    push @errors, { id => "shortcut", msg => "Incorrectly filled field"}
        unless ($c->is_text($i_shortcut));
        
    push @errors, { id => "description", msg => "Incorrectly filled field"}
        unless ($c->is_text($i_description));
        
    push @errors, { id => "access", msg => "Not enough permissions"}
        unless ($c->access->Check("domain.departments.manage"));
    
    unless (@errors) {
        my $path = $c->sql->Q(" SELECT path FROM catalog WHERE id =? ", [ $i_path ])->Value;
        
        push @errors, { id => "path", msg => "Incorrectly filled field"}
            unless ($c->is_path($path));
    
        unless (@errors) {
            $c->sql->Do("
                INSERT INTO catalog (id, title, shortcut, description, path, type, capables)
                    VALUES (?, ?, ?, ?, replace(?, '-',  '')::ltree, ?, ?)
            ", [ $id, $i_title, $i_shortcut, $i_description, $path, 'default', [] ]);
        }
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
    
    push @errors, { id => "path", msg => "Incorrectly filled field"}
        unless ($c->is_path($i_path));
    
    push @errors, { id => "title", msg => "Incorrectly filled field"}
        unless ($c->is_text($i_title));
        
    push @errors, { id => "shortcut", msg => "Incorrectly filled field"}
        unless ($c->is_text($i_shortcut));
        
    push @errors, { id => "description", msg => "Incorrectly filled field"}
        unless ($c->is_text($i_description));
        
    push @errors, { id => "access", msg => "Not enough permissions"}
        unless ($c->access->Check("domain.departments.manage"));

    unless (@errors) {
        my $path = $c->sql->Q(" SELECT path FROM catalog WHERE id =? ", [ $i_path ])->Value;
    
        push @errors, { id => "path", msg => "Incorrectly filled field"}
            unless ($c->is_path($path));

        unless (@errors) {
            $c->sql->Do(" UPDATE catalog SET title=?, shortcut=?, description=?, path=replace(?, '-',  '')::ltree WHERE id=? ",
                [ $i_title, $i_shortcut, $i_description, "$path.$i_id", $i_id ]);
        }
    }

    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors });
}

sub map {
    my $c = shift;

    my @i_members = $c->param("members");
    my $i_group   = $c->param("group") || undef;

    my @errors;
    my $success = $c->json->false;

    push @errors, { id => "group", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_group));

    push @errors, { id => "access", msg => "Not enough permissions"}
        unless ($c->access->Check("domain.departments.manage"));

    unless (@errors) {
        foreach my $member (@i_members) {
            if ($c->is_uuid($member)) {
                $c->sql->Do(" DELETE FROM map_member_to_catalog WHERE id=? AND catalog=? ", [ $member, $i_group ]);
                $c->sql->Do(" INSERT INTO map_member_to_catalog( member, catalog) VALUES (?, ?) ", [ $member, $i_group ]);
            }
        }
    }

    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors });
}

sub unmap {
    my $c = shift;

    my @i_members = $c->param("members");
    my $i_group   = $c->param("group") || undef;

    my @errors;
    my $success = $c->json->false;

    push @errors, { id => "group", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_group));

    push @errors, { id => "access", msg => "Not enough permissions"}
        unless ($c->access->Check("domain.departments.manage"));

    unless (@errors) {
        foreach my $member (@i_members) {
            if ($c->is_uuid($member)) {
                $c->sql->Do(" DELETE FROM map_member_to_catalog WHERE member=? AND catalog=? ", [ $member, $i_group ]);
            }
        }
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
        unless ($c->access->Check("domain.departments.manage"));

    unless (@errors) {
        $c->sql->Do(" DELETE FROM catalog WHERE id =? ", [ $i_id ]);
    }

    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors });
    
}

1;
