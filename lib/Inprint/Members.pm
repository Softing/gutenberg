package Inprint::Members;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use base 'Inprint::BaseController';

sub list {

    my $c = shift;

    my $node = $c->param("node") || "";

    my $result = [];

    if ($node eq 'root-node') {
        $node = '00000000-0000-0000-0000-000000000000';
    }

    $result = $c->sql->Q('
        SELECT distinct t1.id, t1.login, t2.name, t2.shortcut, t2.position
        FROM members t1 LEFT JOIN profiles t2 ON t1.id = t2.id,
            map_member_to_catalog m1
        WHERE m1.member = t1.id AND m1.catalog in (
            SELECT id FROM catalog WHERE path LIKE ?
        ) ORDER BY t2.shortcut
    ', [ "%$node%" ])->Hashes;

    $c->render_json( { data => $result } );
}

sub combo {
    my $c = shift;
    my $result = $c->sql->Q(
        " SELECT id, name, shortcut, description FROM catalog  ")->Hashes;

    $c->render_json( { data => $result } );
}

sub create {

    my $c = shift;

    my $i_login	   = $c->param("login");
    my $i_name	   = $c->param("name");
    my $i_password = $c->param("password");
    my $i_position = $c->param("position");
    my $i_shortcut = $c->param("shortcut");

    my $result = {
        errors => []
    };

    # Check input

    push @{ $result->{errors} }, { id => "login", msg => "" }
        unless $i_login;

    push @{ $result->{errors} }, { id => "name", msg => "" }
        unless $i_name;

    push @{ $result->{errors} }, { id => "password", msg => "" }
        unless $i_password;

    push @{ $result->{errors} }, { id => "position", msg => "" }
        unless $i_position;

    push @{ $result->{errors} }, { id => "shortcut", msg => "" }
        unless $i_shortcut;

    my $login = $c->sql->Q(
        " SELECT true FROM members WHERE login=?", [ $i_login ])->Value;

    if ($login) {
        push @{ $result->{errors} }, { id => "login", msg => "" };
    }

    # Process request

    unless (@{ $result->{errors} }) {

        $result->{success} = 1;

        my $id = $c->uuid();

        $c->sql->Do("
            INSERT INTO members (id, login, password)
                VALUES (?,?,encode( digest(?, 'sha256'), 'hex'))
        ", [ $id, $i_login, $i_password ]);

        $c->sql->Do("
            INSERT INTO map_member_to_catalog (member, catalog)
                VALUES (?,?)
            ", [ $id, '00000000-0000-0000-0000-000000000000' ]);


        $c->sql->Do("
            INSERT INTO profiles (id, name, shortcut, position)
                VALUES (?,?,?,?)
            ", [ $id, $i_name, $i_shortcut, $i_position ]);

    }
    $c->render_json( $result );
}

sub delete {
    my $c = shift;

    my @ids = $c->param("id");

    foreach my $id (@ids) {
        $c->sql->Do(" DELETE FROM members WHERE id=? ", [ $id ]);
    }

    $c->render_json( { success => 1 } );
}


sub map {
    my $c = shift;

    my $i_member      = $c->param("member");
    my $i_catalog     = $c->param("catalog");
    my @i_rules       = $c->param("rules");
    my $i_recursive   = $c->param("recursive");

    $c->sql->Do(
        " DELETE FROM map_member_to_rule WHERE member=? AND catalog=? ",
        [ $i_member, $i_catalog ]);

    foreach my $string (@i_rules) {
        my ($rule, $mode) = split "::", $string;
        $c->sql->Do("
            INSERT INTO map_member_to_rule(member, catalog, rule, mode)
                VALUES (?, ?, ?, ?);
        ", [$i_member, $i_catalog, $rule, $mode]);
    }

    if ($i_recursive) {

        my $groups = $c->sql->Q(
            " SELECT id FROM catalog WHERE path LIKE ? ",
            ["%$i_catalog%"])->Hashes;

        foreach my $item (@$groups) {

            $c->sql->Do(
                " DELETE FROM map_member_to_rule WHERE member=? AND catalog=? ",
                [ $i_member, $item->{id} ]);

            foreach my $string (@i_rules) {
                my ($rule, $mode) = split "::", $string;
                $c->sql->Do("
                    INSERT INTO map_member_to_rule(member, catalog, rule, mode)
                        VALUES (?, ?, ?, ?);
                ", [$i_member, $item->{id}, $rule, $mode]);
            }

        }
    }

    $c->render_json( { success => $c->json->true } );
}

sub mapping {

    my $c = shift;

    my $i_member  = $c->param("member");
    my $i_catalog = $c->param("catalog");

    my $data = $c->sql->Q("
        SELECT member, rule, mode FROM map_member_to_rule WHERE member=? AND catalog=?
    ", [ $i_member, $i_catalog ])->Hashes;

    my $result = {};

    foreach my $item (@$data) {
        $result->{ $item->{rule} } = $item->{mode};
    }

    $c->render_json( { data => $result } );
}

1;
