package Inprint::Fascicle::Templates::Places;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use utf8;
use strict;
use warnings;

use base 'Inprint::BaseController';

sub tree {

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
                SELECT edition1.id, 'edition' as type, edition1.id as edition, edition1.shortcut as text, 'blue-folders-stack' as icon,
                    (
                        EXISTS( SELECT * FROM editions WHERE path <@ edition1.path AND id <> edition1.id )
                        OR
                        EXISTS( SELECT true FROM ad_places WHERE ad_places.edition = edition1.id  )
                    )
                    as have_childs
                FROM editions as edition1
                WHERE
                    edition1.id <> '00000000-0000-0000-0000-000000000000'
                    AND subpath(edition1.path, nlevel(edition1.path) - 2, 1)::text = replace(?, '-', '')::text
                ORDER BY edition1.shortcut
            ) UNION ALL (
                SELECT id, 'place' as type, edition, title as text, 'zone' as icon, false as have_childs
                FROM ad_places
                WHERE edition=?
                ORDER BY shortcut
            )
        ";
        
        push @data, $i_node;
        push @data, $i_node;
        
        my $data = $c->sql->Q("$sql", \@data)->Hashes;
        
        foreach my $item (@$data) {
            my $record = {
                id      => $item->{id},
                edition => $item->{edition},
                text    => $item->{text},
                leaf    => $item->{have_childs},
                icon    => $item->{icon},
                type    => $item->{type},
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
                t1.title, t1.shortcut, t1.description, t1.created, t1.updated
            FROM ad_places t1, editions t2
            WHERE t2.id = t1.edition AND t1.id=?
        ", [ $i_id ])->Hash;
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
    
    my $edition;
    
    unless (@errors) {
        $edition  = $c->sql->Q(" SELECT * FROM editions WHERE id=? ", [ $i_edition ])->Hash;
        push @errors, { id => "edition", msg => "Incorrectly filled field"}
            unless ($edition);
    }
    
    unless (@errors) {
        $c->sql->Do("
            INSERT INTO ad_places(edition, title, shortcut, description, created, updated)
            VALUES (?, ?, ?, ?, now(), now());
        ", [ $edition->{id}, $i_title, $i_shortcut, $i_description ]);
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
    #    unless ($c->access->Check("domain.roles.manage"));
    
    unless (@errors) {
        $c->sql->Do(" UPDATE ad_places SET title=?, shortcut=?, description=?, updated=now() WHERE id=?;",
            [ $i_title, $i_shortcut, $i_description, $i_id ]);
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
                $c->sql->Do(" DELETE FROM ad_places WHERE id=? ", [ $id ]);
            }
        }
    }
    
    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors });
}

1;
