package Inprint::Catalog::Rules;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use base 'Inprint::BaseController';

sub list {

    my $c = shift;

    my $result = $c->sql->Q("
        SELECT t1.id, t1.rule, t1.name, t1.shortcut, t2.name as groupby
        FROM rules t1
            LEFT JOIN rules t2 ON t1.group = t2.rule
        WHERE t1.group is not null
        ORDER BY t2.sortorder, t1.shortcut, t1.name
    ")->Hashes;

    $c->render_json( { data => $result } );
}

sub map {
    my $c = shift;

    my $i_member      = $c->param("member");
    my $i_binding     = $c->param("binding");
    my @i_rules       = $c->param("rules");
    my $i_recursive   = $c->param("recursive");

    $c->sql->Do(" DELETE FROM map_member_to_rule WHERE member=? AND binding=? ", [ $i_member, $i_binding ]);

    foreach my $string (@i_rules) {
        my ($rule, $mode) = split "::", $string;
        $c->sql->Do("
            INSERT INTO map_member_to_rule(member, binding, area, rule)
                VALUES (?, ?, ?, ?);
        ", [$i_member, $i_binding, $mode, $rule]);
    }

    $c->render_json( { success => $c->json->true } );
}

sub mapping {

    my $c = shift;

    my $i_member      = $c->param("member");
    my $i_binding     = $c->param("binding");

    my $data = $c->sql->Q("
        SELECT member, rule, area FROM map_member_to_rule WHERE member=? AND binding=?
    ", [ $i_member, $i_binding ])->Hashes;

    my $result = {};

    foreach my $item (@$data) {
        $result->{ $item->{rule} } = $item->{area};
    }

    $c->render_json( { data => $result } );
}

1;
