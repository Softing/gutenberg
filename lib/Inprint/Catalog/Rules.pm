package Inprint::Catalog::Rules;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use base 'Mojolicious::Controller';

sub list {

    my $c = shift;

    my $i_section = $c->param("section");

    my $result = [];

    if ($i_section) {
        $result = $c->Q("
            (
                SELECT
                    t1.id,
                    t1.section ||'.'|| t1.term ||'.'|| t1.subsection as term,
                    t1.icon, t1.title, t1.description, t1.subsection as groupby
                FROM rules t1
                WHERE t1.section=\$1
                ORDER BY t1.sortorder, t1.title
            ) UNION ALL (
                SELECT
                    t2.id,
                    t2.rule_section ||'.'|| t2.rule_term ||'.'|| t2.rule_subsection as term,
                    t2.rule_icon, t2.rule_title, t2.rule_description,
                    t2.rule_subsection as groupby
                FROM plugins.rules t2
                WHERE t2.rule_section=\$1
                ORDER BY t2.plugin, t2.rule_sortorder, t2.rule_title
            )
        ", [ $i_section ])->Hashes;
    }

    $c->render_json( { data => $result } );
}

sub clear {
    my $c = shift;

    my $i_member    = $c->param("member");
    my $i_section   = $c->param("section");
    my $i_binding   = $c->param("binding");

    # Remove the lower Rules
    if ($i_section ~~ [ "editions", "catalog" ]) {

        $c->Do("
            DELETE FROM map_member_to_rule WHERE
                member=?
                AND section=?
                AND binding = ANY (
                    ARRAY(
                        SELECT id FROM $i_section WHERE path ~
                        ('*.' || replace(?, '-', '') || '.*')::lquery
                    )
                ) ",
            [ $i_member, $i_section, $i_binding ]);

    }

    $c->render_json( { success => $c->json->true } );
}

sub map {
    my $c = shift;

    my $i_member    = $c->param("member");
    my $i_section   = $c->param("section");
    my $i_binding   = $c->param("binding");
    my @i_rules     = $c->param("rules");

    if ($i_section ~~ [ "domain", "editions", "catalog" ])
    {

        $c->Do("
            DELETE FROM map_member_to_rule
                WHERE member=? AND section=? AND binding=? ",
            [ $i_member, $i_section, $i_binding ]);

        foreach my $string (@i_rules) {

            my ($ruleid, $area) = split "::", $string;
            if ($ruleid && $area) {

                my $rule = $c->Q("SELECT * FROM view_rules WHERE id=?", $ruleid)->Hash;

                next unless $rule->{termkey};

                $c->Do("
                    INSERT INTO map_member_to_rule(member, section, binding, area, term, termkey )
                        VALUES (?, ?, ?, ?, ?, ?) ",
                    [ $i_member, $i_section, $i_binding, $area, $ruleid, $rule->{termkey} . ":$area" ]);

            }
        }

    }

    $c->render_json( { success => $c->json->true } );
}

sub mapping {

    my $c = shift;

    my $i_member  = $c->param("member");
    my $i_section = $c->param("section");
    my $i_binding = $c->param("binding");

    my @data;
    my $result = {};

    if ($i_section ~~ [ "domain", "editions", "catalog" ]) {

        # Clear access cache

        $c->Do("
           DELETE FROM cache_access WHERE member=? ",
           [ $i_member ]);

        my $sql = "
            SELECT member, section, area, term FROM map_member_to_rule WHERE member=? AND section=?
        ";

        push @data, $i_member;
        push @data, $i_section;

        if ($i_binding) {
            $sql .= " AND binding=? ";
            push @data, $i_binding;
        }

        my $data = $c->Q($sql, \@data)->Hashes;
        foreach my $item (@$data) {
            $result->{ $item->{term} } = {
                type => "obtained",
                area => $item->{area},
                icon => "key"
            };
        }

    }

    $c->render_json( { data => $result || {} } );
}

1;
