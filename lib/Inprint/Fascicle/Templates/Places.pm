package Inprint::Fascicle::Templates::Places;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use utf8;
use strict;
use warnings;

use base 'Inprint::BaseController';

sub tree {

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
            SELECT id, 'place' as type, fascicle, title as text, 'zone' as icon, false as have_childs
            FROM fascicles_tmpl_places
            WHERE fascicle=?
            ORDER BY title
        ";

        push @data, $i_node;

        my $data = $c->Q("$sql", \@data)->Hashes;

        foreach my $item (@$data) {
            my $record = {
                id      => $item->{id},
                fascicle => $item->{fascicle},
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
        $result = $c->Q("
            SELECT
                t1.id, t1.title, t1.description, t1.created, t1.updated
            FROM fascicles_tmpl_places t1
            WHERE t1.id=?
        ", [ $i_id ])->Hash;
    }

    $success = $c->json->true unless (@errors);
    $c->render_json( { success => $success, errors => \@errors, data => $result } );
}

sub create {
    my $c = shift;

    my $id = $c->uuid();

    my $i_fascicle    = $c->param("fascicle");
    my $i_title       = $c->param("title");
    my $i_description = $c->param("description");

    my @errors;
    my $success = $c->json->false;

    push @errors, { id => "fascicle", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_fascicle));

    push @errors, { id => "title", msg => "Incorrectly filled field"}
        unless ($c->is_text($i_title));

    push @errors, { id => "description", msg => "Incorrectly filled field"}
        unless ($c->is_text($i_description));

    #push @errors, { id => "access", msg => "Not enough permissions"}
    #    unless ($c->objectAccess("domain.roles.manage"));

    my $fascicle; unless (@errors) {
        $fascicle = $c->Q(" SELECT * FROM fascicles WHERE id=? ", [ $i_fascicle ])->Hash;
        push @errors, { id => "fascicle", msg => "Can't find object"}
            unless ($fascicle);
    }

    unless (@errors) {
        $c->Do("
            INSERT INTO fascicles_tmpl_places(id, origin, fascicle, title, description, created, updated)
            VALUES (?, ?, ?, ?, ?, now(), now());
        ", [ $id, $fascicle->{id}, $fascicle->{id}, $i_title, $i_description ]);
    }

    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors });
}

sub update {
    my $c = shift;

    my $i_id          = $c->param("id");
    my $i_title       = $c->param("title");
    my $i_description = $c->param("description");

    my @errors;
    my $success = $c->json->false;

    push @errors, { id => "id", msg => "Incorrectly filled field"}
        unless ($c->is_uuid($i_id));

    push @errors, { id => "title", msg => "Incorrectly filled field"}
        unless ($c->is_text($i_title));

    push @errors, { id => "description", msg => "Incorrectly filled field"}
        unless ($c->is_text($i_description));

    #push @errors, { id => "access", msg => "Not enough permissions"}
    #    unless ($c->objectAccess("domain.roles.manage"));

    unless (@errors) {
        $c->Do(" UPDATE fascicles_tmpl_places SET title=?, description=?, updated=now() WHERE id=?;",
            [ $i_title, $i_description, $i_id ]);
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
    #    unless ($c->objectAccess("domain.roles.manage"));

    unless (@errors) {
        foreach my $id (@ids) {
            if ($c->is_uuid($id)) {
                my $exists = $c->Q(" SELECT EXISTS( SELECT id FROM fascicles_modules WHERE place=? ) ", [ $id ])->Value;
                unless ($exists) {
                    $c->Do(" DELETE FROM fascicles_tmpl_places WHERE id=? ", [ $id ]);
                }
            }
        }
    }

    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors });
}

1;
