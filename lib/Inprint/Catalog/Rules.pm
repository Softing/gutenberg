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
    
    my $i_section = $c->param("section");

    my $result = [];
    
    if ($i_section) {
        $result = $c->sql->Q("
            SELECT t1.id, t1.section ||'.'|| t1.term ||'.'|| t1.subsection as term, t1.icon, t1.title, t1.description, t1.subsection as groupby
            FROM rules t1
            WHERE t1.section=?
            ORDER BY t1.sortorder, t1.title
        ", [ $i_section ])->Hashes;
    }

    $c->render_json( { data => $result } );
}

sub map {
    my $c = shift;

    my $i_member    = $c->param("member");
    my $i_section   = $c->param("section");
    
    my $i_binding   = $c->param("binding");
    my $i_recursive = $c->param("recursive");
    my @i_rules     = $c->param("rules");

    my $success = $c->json->false;

    if ($i_section ~~ [ "domain", "editions", "catalog" ]) {

        $c->sql->Do("
            DELETE FROM map_member_to_rule
            WHERE member=? AND section=? AND binding=?
        ", [ $i_member, $i_section, $i_binding ]);
        
        foreach my $string (@i_rules) {
            my ($rule, $mode) = split "::", $string;
            if ($rule && $mode) {
                $c->sql->Do("
                    INSERT INTO map_member_to_rule(member, section, binding, area, term)
                        VALUES (?, ?, ?, ?, ?);
                ", [$i_member, $i_section, $i_binding, $mode, $rule]);
            }
        }
        
        $success = $c->json->true;
    }

    $c->render_json( { success => $success } );
}

sub mapping {

    my $c = shift;

    my $i_member  = $c->param("member");
    my $i_section = $c->param("section");
    my $i_binding = $c->param("binding");

    my @data;
    my $result = {};
    my $sql = " SELECT member, section, area, term FROM map_member_to_rule WHERE member=? AND section=? ";

    if ($i_section ~~ [ "domain", "editions", "catalog" ]) {

        push @data, $i_member;
        push @data, $i_section;
        
        if ($i_binding) {
            $sql .= " AND binding=? ";
            push @data, $i_binding;
        }
    
        my $data = $c->sql->Q($sql, \@data)->Hashes;
        
        foreach my $item (@$data) {
            $result->{ $item->{term} } = $item->{area};
        }
        
    }

    $c->render_json( { data => $result || {} } );
}

1;
