package Inprint::Principals;

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

    # Get groups
    my $groups = $c->sql->Q("
        SELECT id, name, shortcut, description, 'group' as type
        FROM catalog
        WHERE parent=?
        ORDER BY shortcut
    ", [ $node ])->Hashes;

    # Get members
    my $members = $c->sql->Q("
        SELECT distinct
            t1.id, t2.name, t2.shortcut, t2.position as description,
            'member' as type
        FROM members t1 LEFT JOIN profiles t2 ON t1.id = t2.id,
            map_member_to_catalog m1
        WHERE m1.member = t1.id AND m1.catalog in (
            SELECT id FROM catalog WHERE path LIKE ?
        ) ORDER BY t2.shortcut
    ", [ "%$node%" ])->Hashes;

    @$result = (@$groups, @$members);

    $c->render_json( { data => $result } );
}

sub combo {
    my $c = shift;
    my $result = $c->sql->Q(
        " SELECT id, name, shortcut, description FROM catalog  ")->Hashes;

    $c->render_json( { data => $result } );
}

1;
