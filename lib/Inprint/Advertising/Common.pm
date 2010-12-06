package Inprint::Advertising::Common;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use utf8;
use strict;
use warnings;

use base 'Inprint::BaseController';

sub editions {

    my $c = shift;

    my $i_node = $c->param("node");
    $i_node = '00000000-0000-0000-0000-000000000000' unless ($i_node);
    $i_node = '00000000-0000-0000-0000-000000000000' if ($i_node eq "root-node");
    
    my @errors;
    my $success = $c->json->false;
    
    push @errors, { id => "id", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_node));
    
    my @result;
    
    unless (@errors) {
        my $sql;
        my @data;
        
        $sql = "
            SELECT id, 'edition' as type, shortcut as text, 'blue-folders-stack' as icon,
                EXISTS( SELECT true FROM editions c2 WHERE c2.path ~ ('*.' || replace(?, '-', '')::text || '.*{2}')::lquery ) as have_childs
            FROM editions
            WHERE id <> '00000000-0000-0000-0000-000000000000' AND subpath(path, nlevel(path) - 2, 1)::text = replace(?, '-', '')::text
            ORDER BY shortcut
        ";
        push @data, $i_node;
        push @data, $i_node;
        
        my $data = $c->sql->Q("$sql", \@data)->Hashes;
        
        foreach my $item (@$data) {
            my $record = {
                id   => $item->{id},
                text => $item->{text},
                icon => $item->{icon},
                type => $item->{type},
            };
            if ( $item->{have_childs} ) {
                $record->{leaf} = $c->json->false;
            } else {
                $record->{leaf} = $c->json->true;
            }
            push @result, $record;
        }
    }

    $success = $c->json->true unless (@errors);
    
    $c->render_json( \@result );
}

sub fascicles {

    my $c = shift;

    my $i_node = $c->param("node");
    $i_node = '00000000-0000-0000-0000-000000000000' unless ($i_node);
    $i_node = '00000000-0000-0000-0000-000000000000' if ($i_node eq "root-node");
    
    my @errors;
    my $success = $c->json->false;
    
    push @errors, { id => "id", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_node));
    
    my @result;
    
    unless (@errors) {
        my $sql;
        my @data;
        
        $sql = "
            (
                SELECT id, 'edition' as type, id as edition, null as fascicle, shortcut as text, 'blue-folders-stack' as icon,
                    EXISTS(
                        SELECT true FROM fascicles WHERE fascicles.edition = editions.id AND is_system = false AND is_enabled = true 
                    ) as have_childs
                FROM editions
                WHERE id <> '00000000-0000-0000-0000-000000000000' AND subpath(path, nlevel(path) - 2, 1)::text = replace(?, '-', '')::text
                ORDER BY shortcut
            ) UNION ALL (
                SELECT id, 'fascicle' as type, edition, id as fascicle, shortcut as text, 'blue-folder' as icon,
                    false as have_childs
                FROM fascicles
                WHERE is_system = false AND is_enabled = true AND edition = ?
                ORDER BY shortcut
            )
        ";
        push @data, $i_node;
        push @data, $i_node;
        
        my $data = $c->sql->Q("$sql", \@data)->Hashes;
        
        foreach my $item (@$data) {
            my $record = {
                id   => $item->{id},
                text => $item->{text},
                leaf => $item->{have_childs},
                icon => $item->{icon},
                type => $item->{type},
                
                edition  => $item->{edition},
                fascicle => $item->{fascicle},
            };
            if ( $item->{have_childs} ) {
                $record->{leaf} = $c->json->false;
            } else {
                $record->{leaf} = $c->json->true;
            }
            push @result, $record;
        }
    }

    $success = $c->json->true unless (@errors);
    
    $c->render_json( \@result );
}

sub places {

    my $c = shift;

    my $i_node = $c->param("node");
    $i_node = '00000000-0000-0000-0000-000000000000' unless ($i_node);
    $i_node = '00000000-0000-0000-0000-000000000000' if ($i_node eq "root-node");
    
    my @errors;
    my $success = $c->json->false;
    
    push @errors, { id => "id", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_node));
    
    my @result;
    
    unless (@errors) {
        my $sql;
        my @data;
        
        $sql = "
            (
                SELECT id, 'edition' as type, id as edition, null as fascicle, shortcut as text, 'blue-folders-stack' as icon,
                    EXISTS(
                        SELECT true FROM fascicles WHERE fascicles.edition = editions.id AND is_system = false AND is_enabled = true 
                    ) as have_childs
                FROM editions
                WHERE id <> '00000000-0000-0000-0000-000000000000' AND subpath(path, nlevel(path) - 2, 1)::text = replace(?, '-', '')::text
                ORDER BY shortcut
            ) UNION ALL (
                SELECT id, 'fascicle' as type, edition, id as fascicle, shortcut as text, 'blue-folder' as icon,
                    EXISTS(
                        SELECT true FROM ad_places places WHERE places.fascicle=fascicles.id
                    ) as have_childs
                FROM fascicles
                WHERE is_system = false AND is_enabled = true AND edition = ?
                ORDER BY shortcut
            ) UNION ALL (
                SELECT id, 'module' as type, edition, fascicle, title as text, 'zone' as icon, false as have_childs
                FROM ad_places
                WHERE fascicle=?
                ORDER BY shortcut
            )
        ";
        push @data, $i_node;
        push @data, $i_node;
        push @data, $i_node;
        
        my $data = $c->sql->Q("$sql", \@data)->Hashes;
        
        foreach my $item (@$data) {
            my $record = {
                id   => $item->{id},
                text => $item->{text},
                leaf => $item->{have_childs},
                icon => $item->{icon},
                type => $item->{type},
            };
            if ( $item->{have_childs} ) {
                $record->{leaf} = $c->json->false;
            } else {
                $record->{leaf} = $c->json->true;
            }
            push @result, $record;
        }
    }

    $success = $c->json->true unless (@errors);
    
    $c->render_json( \@result );
}

1;
