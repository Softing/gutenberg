package Inprint::Catalog::Organization;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use Inprint::Check;

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
            SELECT *, ( SELECT count(*) FROM catalog c2 WHERE c2.path ~ ('*.' || replace(?, '-', '')::text || '.*{2}')::lquery ) as have_childs
            FROM catalog
            WHERE
                id <> '00000000-0000-0000-0000-000000000000'
                AND subpath(path, nlevel(path) - 2, 1)::text = replace(?, '-', '')::text
        ";
        push @data, $i_node;
        push @data, $i_node;

        my $data = $c->sql->Q("$sql ORDER BY shortcut", \@data)->Hashes;

        foreach my $item (@$data) {
            my $record = {
                id   => $item->{id},
                icon => "folders",
                text => $item->{shortcut},
                leaf => $c->json->true,
                data => $item
            };
            if ( $item->{have_childs} ) {
                $record->{leaf} = $c->json->false;
            }
            push @result, $record;
        }
    }

    $success = $c->json->true unless (@errors);

    $c->render_json( \@result );
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

    Inprint::Check::path($c, \@errors, "path", $i_path);
    Inprint::Check::text($c, \@errors, "title", $i_title);
    Inprint::Check::text($c, \@errors, "shortcut", $i_shortcut);

    Inprint::Check::access($c, \@errors, "domain.departments.manage");

    my $parent = Inprint::Check::department($c, \@errors, $i_path);

    unless (@errors) {
        $c->sql->Do("
            INSERT INTO catalog (id, title, shortcut, description, path, type, capables)
                VALUES (?, ?, ?, ?, replace(?, '-',  '')::ltree, ?, ?)
        ", [ $id, $i_title, $i_shortcut, $i_description, $parent->{path}, 'default', [] ]);
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

    Inprint::Check::uuid($c, \@errors, "id", $i_id);
    Inprint::Check::path($c, \@errors, "path", $i_path);
    Inprint::Check::text($c, \@errors, "title", $i_title);
    Inprint::Check::text($c, \@errors, "shortcut", $i_shortcut);

    Inprint::Check::access($c, \@errors, "domain.departments.manage");

    push @errors, { id => "id", msg => "Incorrectly filled field"}
        if ($i_id eq "00000000-0000-0000-0000-000000000000");

    my $parent = Inprint::Check::department($c, \@errors, $i_path);

    unless (@errors) {
        unless (@errors) {
            $c->sql->Do(" UPDATE catalog SET title=?, shortcut=?, description=?, path=replace(?, '-',  '')::ltree WHERE id=? ",
                [ $i_title, $i_shortcut, $i_description, $parent->{path} . ".$i_id", $i_id ]);
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

    Inprint::Check::uuid($c, \@errors, "id", $i_id);
    Inprint::Check::access($c, \@errors, "domain.departments.manage");

    push @errors, { id => "id", msg => "Incorrectly filled field"}
        if ($i_id eq "00000000-0000-0000-0000-000000000000");

    unless (@errors) {
        $c->sql->Do(" DELETE FROM catalog WHERE id =? ", [ $i_id ]);
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

    Inprint::Check::uuid($c, \@errors, "group", $i_group);
    Inprint::Check::access($c, \@errors, "domain.departments.manage");

    foreach my $member (@i_members) {
        Inprint::Check::uuid($c, \@errors, "member", $member);
    }

    unless (@errors) {
        foreach my $member (@i_members) {
            $c->sql->Do(" DELETE FROM map_member_to_catalog WHERE member=? AND catalog=? ", [ $member, $i_group ]);
            $c->sql->Do(" INSERT INTO map_member_to_catalog( member, catalog) VALUES (?, ?) ", [ $member, $i_group ]);
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

    Inprint::Check::uuid($c, \@errors, "group", $i_group);
    Inprint::Check::access($c, \@errors, "domain.departments.manage");

    foreach my $member (@i_members) {
        Inprint::Check::uuid($c, \@errors, "member", $member);
    }

    unless (@errors) {
        foreach my $member (@i_members) {
            $c->sql->Do(" DELETE FROM map_member_to_catalog WHERE member=? AND catalog=? ", [ $member, $i_group ]);
        }
    }

    $success = $c->json->true unless (@errors);
    $c->render_json({ success => $success, errors => \@errors });
}

1;
