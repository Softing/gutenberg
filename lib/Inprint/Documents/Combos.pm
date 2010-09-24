package Inprint::Documents::Combos;

# Inprint Content 4.5
# Copyright(c) 2001-2010, Softing, LLC.
# licensing@softing.ru
# http://softing.ru/license

use strict;
use warnings;

use base 'Inprint::BaseController';

#'id', 'icon', 'title', 'shortcut', 'description'

sub groups {

    my $c = shift;

    my $result = $c->sql->Q("
        SELECT
            t1.id, t1.title, t1.shortcut, t1.description,
            repeat('&nbsp;', t2.depth * 2) || '- ' || t1.shortcut as path
        FROM catalog t1, catalog_tree t2
        WHERE
            t2.parent = '00000000-0000-0000-0000-000000000000' AND t2.child = t1.id
        ORDER BY named_path, t1.shortcut
    ")->Hashes;

    $c->render_json( { data => $result } );
}

sub fascicles {
    
    my $c = shift;
    
    my $result = $c->sql->Q("
        SELECT id, title, shortcut, description
        FROM fascicles;
    ")->Hashes;
    
    $c->render_json( { data => $result } );
}

sub headlines {

    my $c = shift;
    
    my $cgi_fascicle = $c->param("flt_fascicle");

    my $result = $c->sql->Q("
        SELECT t1.id, t1.rule, t1.name, t1.shortcut, t2.name as groupby
        FROM rules t1
            LEFT JOIN rules t2 ON t1.group = t2.rule
        WHERE t1.group is not null
        ORDER BY t2.sortorder, t1.shortcut, t1.name
    ")->Hashes;

    $c->render_json( { data => $result } );
}

sub rubrics {

    my $c = shift;
    
    my $cgi_fascicle = $c->param("flt_fascicle");

    my $result = $c->sql->Q("
        SELECT t1.id, t1.rule, t1.name, t1.shortcut, t2.name as groupby
        FROM rules t1
            LEFT JOIN rules t2 ON t1.group = t2.rule
        WHERE t1.group is not null
        ORDER BY t2.sortorder, t1.shortcut, t1.name
    ")->Hashes;

    $c->render_json( { data => $result } );
}

sub holders {

    my $c = shift;

    my $sql;
    $sql = "
        SELECT t1.id, t2.title, t2.shortcut, position as description
        FROM members t1, profiles t2
        WHERE t1.id = t2.id
        ORDER BY t2.title
    ";
    
    my $result = $c->sql->Q($sql)->Hashes;

    $c->render_json( { data => $result } );
}

sub managers {

    my $c = shift;

    my $sql;
    $sql = "
        SELECT t1.id, t2.title, t2.shortcut, position as description
        FROM members t1, profiles t2
        WHERE t1.id = t2.id
        ORDER BY t2.title
    ";

    my $result = $c->sql->Q($sql)->Hashes;

    $c->render_json( { data => $result } );
}

sub progress {

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

1;
