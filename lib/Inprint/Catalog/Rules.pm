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
                WHERE t1.section=?
                ORDER BY t1.sortorder, t1.title
            ) UNION (
                SELECT
                    t2.id,
                    t2.rule_section ||'.'|| t2.rule_term ||'.'|| t2.rule_subsection as term,
                    t2.rule_icon, t2.rule_title, t2.rule_description,
                    t2.rule_subsection as groupby
                FROM plugins.rules t2
                WHERE t2.rule_section=?
                ORDER BY t2.plugin, t2.rule_sortorder, t2.rule_title
            )
        ", [ $i_section, $i_section ])->Hashes;
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

        $c->Do("
            DELETE FROM cache_access WHERE
                member=?
                AND type=?
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

        foreach my $string (@i_rules)
        {
            my ($rule, $mode) = split "::", $string;
            if ($rule && $mode) {
                $c->Do("
                    INSERT INTO map_member_to_rule(member, section, binding, area, term)
                        VALUES (?, ?, ?, ?, ?) ",
                    [$i_member, $i_section, $i_binding, $mode, $rule]);
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

        my $sql1 = " SELECT member, section, area, term FROM map_member_to_rule WHERE member=? AND section=? ";
        my $sql2 = " SELECT terms FROM cache_access WHERE member=? AND type=? ";

        push @data, $i_member;
        push @data, $i_section;

        if ($i_binding) {
            $sql1 .= " AND binding=? ";
            $sql2 .= " AND binding=? ";

            push @data, $i_binding;
        }

        my $data1 = $c->Q($sql1, \@data)->Hashes;
        foreach my $item (@$data1) {
            $result->{ $item->{term} } = {
                type => "obtained",
                area => $item->{area},
                icon => "key"
            };
        }

        my $data2 = $c->Q($sql2, \@data)->Values;
        foreach my $item (@$data2) {
            foreach my $term (@$item) {

                my ($term, $area) = split /:/, $term;

                my $term_obj = $c->Q(
                    "SELECT * FROM view_rules WHERE term_text = ?", [ $term ])->Hash;

                next if $result->{ $term_obj->{id} };
                $result->{ $term_obj->{id} } = {
                    type => "inherited",
                    area => $area || $i_section,
                    icon => "key--arrow"
                }
            }
        }

    }

    $c->render_json( { data => $result || {} } );
}

1;
