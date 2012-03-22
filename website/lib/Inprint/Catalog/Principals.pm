package Inprint::Catalog::Principals;

# Inprint Content 5.0
# Copyright(c) 2001-2011, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use base 'Mojolicious::Controller';

sub list {

    my $c = shift;

    my $i_filter = $c->param("filter") || undef;
    my $i_node   = $c->param("node") || "";

    my $result = [];

    if ($i_node eq 'root-node') {
        $i_node = '00000000-0000-0000-0000-000000000000';
    }

    # Get groups
    my $sql1 = "
        SELECT id, shortcut as title, description, 'group' as type
        FROM catalog
        WHERE path ~ ('*.' || replace(?, '-', '')::text || '.*{1}')::lquery
    ";
    my @data1 = ($i_node);

    if ($i_filter) {
        $sql1 .= " AND (shortcut LIKE ? OR description LIKE ?) ";
        push @data1, "%$i_filter%";
        push @data1, "%$i_filter%";
    }

    my $groups = $c->Q(" $sql1 ORDER BY shortcut", \@data1)->Hashes;

    # Get members

    my $sql2 = "
        SELECT distinct
            t1.id, t2.shortcut as title, t2.job_position as description,
            'member' as type
        FROM members t1
            LEFT JOIN profiles t2 ON t1.id = t2.id, map_member_to_catalog m1
        WHERE
            m1.member = t1.id
            AND m1.catalog in (SELECT id FROM catalog WHERE path ~ ('*.' || replace(?, '-', '')::text || '.*')::lquery )
    ";
    my @data2 = ($i_node);

    if ($i_filter) {
        $sql2 .= " AND (t1.login ILIKE ? OR t2.shortcut ILIKE ? OR t2.job_position ILIKE ?) ";
        push @data2, "%$i_filter%";
        push @data2, "%$i_filter%";
        push @data2, "%$i_filter%";
    }

    my $members = $c->Q(" $sql2  ORDER BY t2.shortcut ", \@data2)->Hashes;

    @$result = (@$groups, @$members);

    $c->render_json( { data => $result } );
}

1;
